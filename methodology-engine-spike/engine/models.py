"""Core models for the methodology engine."""
from typing import Dict, List, Optional, Any, Set
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
import hashlib
import json


class AssetType(Enum):
    """Types of assets that can be discovered."""
    HOST = "host"
    SERVICE = "service"
    CREDENTIAL = "credential"
    NETWORK_SEGMENT = "network_segment"
    WEB_APPLICATION = "web_application"
    DATABASE = "database"
    DOMAIN_CONTROLLER = "domain_controller"
    VULNERABILITY = "vulnerability"
    OTHER = "other"


class TriggerType(Enum):
    """Types of triggers that can fire methodologies."""
    ASSET_DISCOVERED = "asset_discovered"
    PROPERTY_MATCH = "property_match"
    ASSET_COMBINATION = "asset_combination"
    THRESHOLD_REACHED = "threshold_reached"


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
class MethodologyStep:
    """A single step in a methodology."""
    id: str
    name: str
    description: str
    command_template: str
    order: int = 0
    timeout_seconds: Optional[int] = None
    expected_outputs: List[str] = field(default_factory=list)
    asset_discovery_patterns: List[Dict[str, str]] = field(default_factory=list)

    def resolve_command(self, assets: List[Asset]) -> str:
        """Resolve command template with asset values."""
        command = self.command_template

        # Replace placeholders with asset values
        for asset in assets:
            # Common replacements
            command = command.replace("{asset_id}", asset.id)
            command = command.replace("{asset_name}", asset.name)

            # Property-based replacements
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
