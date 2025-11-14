"""Core models for the methodology engine."""
from typing import Dict, List, Optional, Any, Set
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
import hashlib
import json


class AssetType(Enum):
    """Types of assets that can be discovered during an engagement."""
    # Network Layer
    NETWORK_SEGMENT = "network_segment"      # 10.1.1.0/24, VLAN 100
    NETWORK_INTERFACE = "network_interface"  # NIC on a host (for pivoting)
    FIREWALL = "firewall"                    # Firewall/gateway device
    ROUTER = "router"                        # Router device

    # Host Layer
    HOST = "host"                            # Physical/virtual machine

    # Service Layer
    SERVICE = "service"                      # Running service (SMB, HTTP, SSH)
    WEB_APPLICATION = "web_application"      # Web app/CMS (WordPress, etc)
    DATABASE = "database"                    # Database instance
    DOMAIN_CONTROLLER = "domain_controller"  # Active Directory DC

    # Application Layer
    APPLICATION = "application"              # Installed software (Tomcat, IIS)
    FILE_SHARE = "file_share"               # SMB/NFS share

    # Data Layer
    FILE = "file"                           # Individual file
    CREDENTIAL = "credential"               # Username/password/hash/key/token
    CERTIFICATE = "certificate"             # SSL/TLS certificate
    SECRET = "secret"                       # API key, token, secret

    # Identity Layer
    USER_ACCOUNT = "user_account"           # User account on system
    GROUP = "group"                         # User group (local or AD)

    # Security Layer
    VULNERABILITY = "vulnerability"          # CVE, misconfiguration
    FINDING = "finding"                      # Security finding / issue

    # Domain / Infrastructure
    DOMAIN = "domain"                        # DNS domain (example.com)

    # Other
    OTHER = "other"


class TriggerType(Enum):
    """Types of triggers that can fire methodologies."""
    ASSET_DISCOVERED = "asset_discovered"
    PROPERTY_MATCH = "property_match"
    ASSET_COMBINATION = "asset_combination"
    THRESHOLD_REACHED = "threshold_reached"


class RelationshipType(Enum):
    """Types of relationships between assets."""
    # Containment & Hierarchy
    CONTAINS = "contains"                    # Segment contains Host, Host contains Service
    MEMBER_OF = "member_of"                 # Host member of Segment, User member of Group
    INSTALLED_ON = "installed_on"           # Application installed on Host
    RUNS_ON = "runs_on"                     # Service runs on Host
    HOSTED_ON = "hosted_on"                 # File hosted on FileShare

    # Connectivity & Network
    CONNECTED_TO = "connected_to"           # Network connected to Network via Router
    CAN_PIVOT_TO = "can_pivot_to"          # Host can pivot to Network (multi-NIC)
    ROUTES_TO = "routes_to"                 # Network routes to Network
    ACCESSIBLE_FROM = "accessible_from"     # Service accessible from Network

    # Access Control & Permissions
    BLOCKED_BY = "blocked_by"               # Network blocked by Firewall
    ALLOWED_BY = "allowed_by"               # Host allowed by Firewall rule
    ALLOWS_ACCESS_TO = "allows_access_to"   # Firewall allows access to Network
    REQUIRES = "requires"                   # Service requires Credential
    WORKS_ON = "works_on"                   # Credential works on Host/Service
    GRANTS_ACCESS_TO = "grants_access_to"   # Credential grants access to Host
    HAS_PERMISSION_ON = "has_permission_on" # User has permission on File/Share

    # Service & Execution
    EXPOSES = "exposes"                     # Service exposes Vulnerability
    EXPLOITS = "exploits"                   # Vulnerability exploits Service
    ENABLES = "enables"                     # Application enables PrivEsc

    # Identity & Trust
    TRUSTS = "trusts"                       # Domain trusts Domain, Host trusts Host
    DOMAIN_MEMBER = "domain_member"         # Host member of Domain
    OWNS = "owns"                           # User owns File/Process
    MANAGES = "manages"                     # User manages Host/Service

    # Data Flow
    COMMUNICATES_WITH = "communicates_with" # Service communicates with Service
    DEPENDS_ON = "depends_on"               # Service depends on Database
    REPLICATES_TO = "replicates_to"        # DC replicates to DC


@dataclass
class AssetRelationship:
    """Represents a relationship between two assets."""
    id: str
    source_asset_id: str
    target_asset_id: str
    relationship_type: RelationshipType
    properties: Dict[str, Any] = field(default_factory=dict)
    confidence: float = 1.0
    discovered_at: datetime = field(default_factory=datetime.now)
    metadata: Dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for JSON serialization."""
        return {
            "id": self.id,
            "source_asset_id": self.source_asset_id,
            "target_asset_id": self.target_asset_id,
            "relationship_type": self.relationship_type.value,
            "properties": self.properties,
            "confidence": self.confidence,
            "discovered_at": self.discovered_at.isoformat(),
            "metadata": self.metadata
        }


@dataclass
class Asset:
    """Represents a discovered asset in the engagement."""
    id: str
    type: AssetType
    name: str
    properties: Dict[str, Any] = field(default_factory=dict)
    confidence: float = 1.0
    discovered_at: datetime = field(default_factory=datetime.now)
    metadata: Dict[str, Any] = field(default_factory=dict)

    def matches_properties(self, required_properties: Dict[str, Any]) -> bool:
        """Check if this asset matches the required properties."""
        for key, value in required_properties.items():
            if key not in self.properties:
                return False

            asset_value = self.properties[key]

            # Handle special operators
            if isinstance(value, dict):
                if "$exists" in value:
                    if value["$exists"] and key not in self.properties:
                        return False
                    if not value["$exists"] and key in self.properties:
                        return False
                if "$in" in value:
                    if asset_value not in value["$in"]:
                        return False
                if "$gt" in value:
                    if not (isinstance(asset_value, (int, float)) and asset_value > value["$gt"]):
                        return False
                if "$lt" in value:
                    if not (isinstance(asset_value, (int, float)) and asset_value < value["$lt"]):
                        return False
            else:
                # Direct value comparison
                if asset_value != value:
                    return False

        return True

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for JSON serialization."""
        return {
            "id": self.id,
            "type": self.type.value,
            "name": self.name,
            "properties": self.properties,
            "confidence": self.confidence,
            "discovered_at": self.discovered_at.isoformat(),
            "metadata": self.metadata
        }


@dataclass
class DeduplicationConfig:
    """Configuration for trigger deduplication."""
    enabled: bool = True
    strategy: str = "signature_based"  # signature_based, cooldown, max_executions
    signature_fields: List[str] = field(default_factory=list)  # Asset properties to include in signature
    cooldown_seconds: Optional[int] = None
    max_executions: Optional[int] = None

    def generate_signature(self, assets: List[Asset], methodology_id: str) -> str:
        """Generate a unique signature for this asset combination."""
        if not self.signature_fields:
            # Use all asset IDs by default
            asset_ids = sorted([a.id for a in assets])
            sig_data = f"{methodology_id}:{':'.join(asset_ids)}"
        else:
            # Use specific fields from asset properties
            sig_parts = [methodology_id]
            for asset in sorted(assets, key=lambda a: a.id):
                for field in self.signature_fields:
                    value = asset.properties.get(field, "")
                    sig_parts.append(f"{field}={value}")
            sig_data = ":".join(sig_parts)

        return hashlib.sha256(sig_data.encode()).hexdigest()[:16]


@dataclass
class Trigger:
    """Defines when a methodology should execute."""
    id: str
    type: TriggerType
    asset_type: Optional[AssetType] = None
    required_properties: Dict[str, Any] = field(default_factory=dict)
    required_count: int = 1  # How many assets must match
    priority: int = 5  # 1 (highest) to 10 (lowest)
    description: str = ""
    deduplication: DeduplicationConfig = field(default_factory=DeduplicationConfig)

    def matches(self, assets: List[Asset]) -> bool:
        """Check if this trigger matches the given assets."""
        if self.type != TriggerType.ASSET_DISCOVERED and self.type != TriggerType.PROPERTY_MATCH:
            return False

        matching_assets = []
        for asset in assets:
            # Check asset type if specified
            if self.asset_type and asset.type != self.asset_type:
                continue

            # Check required properties
            if self.required_properties and not asset.matches_properties(self.required_properties):
                continue

            matching_assets.append(asset)

        # Check if we have enough matching assets
        return len(matching_assets) >= self.required_count

    def get_matching_assets(self, assets: List[Asset]) -> List[Asset]:
        """Get all assets that match this trigger."""
        matching = []
        for asset in assets:
            if self.asset_type and asset.type != self.asset_type:
                continue
            if self.required_properties and not asset.matches_properties(self.required_properties):
                continue
            matching.append(asset)
        return matching


@dataclass
class CommandAlternative:
    """A command alternative for a methodology step."""
    tool: str
    platforms: List[str] = field(default_factory=lambda: ["any"])
    command: str = ""
    preferred: bool = False
    notes: str = ""
    requires_elevation: bool = False

    def resolve_command(self, assets: List[Asset]) -> str:
        """Resolve command template with asset values."""
        resolved = self.command

        # Replace placeholders with asset values
        for asset in assets:
            # Common replacements
            resolved = resolved.replace("{asset_id}", asset.id)
            resolved = resolved.replace("{asset_name}", asset.name)

            # Property-based replacements
            for key, value in asset.properties.items():
                placeholder = f"{{{key}}}"
                resolved = resolved.replace(placeholder, str(value))

        return resolved


@dataclass
class MethodologyStep:
    """A single step in a methodology."""
    id: str
    name: str
    description: str
    command_template: str = ""  # Legacy: single command (kept for backward compatibility)
    commands: List[CommandAlternative] = field(default_factory=list)  # New: multiple command alternatives
    order: int = 0
    timeout_seconds: Optional[int] = None
    expected_outputs: List[str] = field(default_factory=list)
    asset_discovery_patterns: List[Dict[str, str]] = field(default_factory=list)

    def resolve_command(self, assets: List[Asset], platform: str = "linux") -> str:
        """Resolve command template with asset values.

        Args:
            assets: List of assets to use for placeholder replacement
            platform: Target platform (linux, windows, macos, any)

        Returns:
            Resolved command string
        """
        # If using new multi-command format
        if self.commands:
            # Find preferred command for platform
            for cmd_alt in self.commands:
                if cmd_alt.preferred and (platform in cmd_alt.platforms or "any" in cmd_alt.platforms):
                    return cmd_alt.resolve_command(assets)

            # Fall back to any compatible command
            for cmd_alt in self.commands:
                if platform in cmd_alt.platforms or "any" in cmd_alt.platforms:
                    return cmd_alt.resolve_command(assets)

            # Last resort: first command
            if self.commands:
                return self.commands[0].resolve_command(assets)

        # Fall back to legacy single command template
        command = self.command_template
        for asset in assets:
            command = command.replace("{asset_id}", asset.id)
            command = command.replace("{asset_name}", asset.name)

            for key, value in asset.properties.items():
                placeholder = f"{{{key}}}"
                command = command.replace(placeholder, str(value))

        return command


@dataclass
class Methodology:
    """A complete methodology definition."""
    id: str
    name: str
    description: str
    category: str  # recon, enumeration, exploitation, post_exploitation
    risk_level: str  # low, medium, high, critical
    triggers: List[Trigger] = field(default_factory=list)
    steps: List[MethodologyStep] = field(default_factory=list)
    batch_compatible: bool = True  # Can this be batched with similar executions?
    metadata: Dict[str, Any] = field(default_factory=dict)

    def can_batch_with(self, other: 'Methodology') -> bool:
        """Check if this methodology can be batched with another."""
        if not self.batch_compatible or not other.batch_compatible:
            return False

        # Must be same methodology or explicitly compatible
        if self.id == other.id:
            return True

        # Check metadata for explicit batch compatibility
        compatible_with = self.metadata.get("batch_compatible_with", [])
        return other.id in compatible_with


@dataclass
class TriggerMatch:
    """Represents a trigger that has matched and is ready to execute."""
    trigger_id: str
    methodology_id: str
    matched_assets: List[Asset]
    priority: int
    confidence: float
    signature: str
    matched_at: datetime = field(default_factory=datetime.now)
    executed: bool = False
    batched: bool = False
    batch_id: Optional[str] = None

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for JSON serialization."""
        return {
            "trigger_id": self.trigger_id,
            "methodology_id": self.methodology_id,
            "matched_assets": [a.to_dict() for a in self.matched_assets],
            "priority": self.priority,
            "confidence": self.confidence,
            "signature": self.signature,
            "matched_at": self.matched_at.isoformat(),
            "executed": self.executed,
            "batched": self.batched,
            "batch_id": self.batch_id
        }


@dataclass
class BatchCommand:
    """A batch command generated from multiple trigger matches."""
    id: str
    methodology_id: str
    command: str
    trigger_matches: List[TriggerMatch]
    target_count: int
    created_at: datetime = field(default_factory=datetime.now)
    metadata: Dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for JSON serialization."""
        return {
            "id": self.id,
            "methodology_id": self.methodology_id,
            "command": self.command,
            "trigger_matches": [tm.to_dict() for tm in self.trigger_matches],
            "target_count": self.target_count,
            "created_at": self.created_at.isoformat(),
            "metadata": self.metadata
        }
