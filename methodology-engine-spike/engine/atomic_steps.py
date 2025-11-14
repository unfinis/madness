"""Atomic step definitions and step execution models."""
from typing import Dict, List, Optional, Any, Callable
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from .models import Asset, AssetType


class StepPhase(Enum):
    """Phases of the penetration testing lifecycle."""
    DISCOVERY = "discovery"              # Host/network discovery
    PORT_SCANNING = "port_scanning"      # Port enumeration
    SERVICE_IDENTIFICATION = "service_identification"  # Banner grab, version detection
    SERVICE_ENUMERATION = "service_enumeration"        # Service-specific enumeration
    VULNERABILITY_ASSESSMENT = "vulnerability_assessment"  # Vuln scanning
    EXPLOITATION = "exploitation"        # Brute force, exploit attempts
    POST_EXPLOITATION = "post_exploitation"  # Privilege escalation, lateral movement
    REPORTING = "reporting"              # Evidence collection


class StepStatus(Enum):
    """Status of a step execution."""
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"
    SKIPPED = "skipped"
    TIMEOUT = "timeout"


class TriggerConditionType(Enum):
    """Types of trigger conditions."""
    ASSET_CREATED = "asset_created"           # New asset created
    PROPERTY_SET = "property_set"             # Property value set
    PROPERTY_UPDATED = "property_updated"     # Property value changed
    PROPERTY_MATCH = "property_match"         # Property matches pattern
    PROPERTY_NULL = "property_null"           # Property is null/missing
    PROPERTY_NOT_NULL = "property_not_null"   # Property exists and has value


@dataclass
class StepTriggerCondition:
    """Condition that determines when a step should execute."""
    condition_type: TriggerConditionType
    asset_type: AssetType
    property_name: Optional[str] = None
    property_value: Optional[Any] = None
    property_pattern: Optional[Dict[str, Any]] = None  # MongoDB-style queries

    def matches(self, asset: Asset, property_changed: Optional[str] = None) -> bool:
        """Check if this condition matches the given asset state."""
        # Check asset type
        if asset.type != self.asset_type:
            return False

        # Handle different condition types
        if self.condition_type == TriggerConditionType.ASSET_CREATED:
            return True  # Asset was just created

        if self.condition_type == TriggerConditionType.PROPERTY_NULL:
            if self.property_name:
                return self.property_name not in asset.properties or asset.properties[self.property_name] is None

        if self.condition_type == TriggerConditionType.PROPERTY_NOT_NULL:
            if self.property_name:
                return self.property_name in asset.properties and asset.properties[self.property_name] is not None

        if self.condition_type == TriggerConditionType.PROPERTY_SET:
            if self.property_name and property_changed:
                return property_changed == self.property_name

        if self.condition_type == TriggerConditionType.PROPERTY_MATCH:
            if self.property_name and self.property_pattern:
                return asset.matches_properties({self.property_name: self.property_pattern})

        return False


@dataclass
class CommandDefinition:
    """A command to execute for a step."""
    tool: str
    command: str
    platforms: List[str] = field(default_factory=lambda: ["linux", "macos", "windows"])
    timeout: int = 300
    preferred: bool = True
    requires_elevation: bool = False
    notes: str = ""

    def resolve_placeholders(self, asset: Asset, context: Dict[str, Any] = None) -> str:
        """Resolve command placeholders with asset properties."""
        resolved = self.command

        # Replace asset properties
        for key, value in asset.properties.items():
            placeholder = f"{{{key}}}"
            resolved = resolved.replace(placeholder, str(value))

        # Replace context variables if provided
        if context:
            for key, value in context.items():
                placeholder = f"{{{key}}}"
                resolved = resolved.replace(placeholder, str(value))

        return resolved


@dataclass
class OutputParser:
    """Configuration for parsing command output."""
    parser_type: str  # "regex", "json", "xml", "nmap_xml", "custom"
    patterns: Dict[str, str] = field(default_factory=dict)  # field_name -> regex pattern
    creates_assets: List[Dict[str, Any]] = field(default_factory=list)  # Asset creation rules
    updates_asset: Dict[str, Any] = field(default_factory=dict)  # Asset update rules
    custom_parser: Optional[Callable] = None  # Custom parsing function


@dataclass
class AtomicStep:
    """A single atomic step in the attack queue."""
    # Required fields (no defaults)
    id: str
    name: str
    description: str
    phase: StepPhase
    trigger_conditions: List[StepTriggerCondition]
    commands: List[CommandDefinition]

    # Optional fields (with defaults)
    prerequisites: List[Dict[str, Any]] = field(default_factory=list)  # Additional requirements
    priority: int = 5  # 1 (highest) to 10 (lowest)
    timeout_seconds: int = 300
    output_parser: Optional[OutputParser] = None
    next_step_ids: List[str] = field(default_factory=list)  # Steps to queue on success
    failure_step_ids: List[str] = field(default_factory=list)  # Steps to queue on failure
    deduplication_signature_fields: List[str] = field(default_factory=list)
    cooldown_seconds: Optional[int] = None
    batch_compatible: bool = False
    max_batch_size: int = 100
    tags: List[str] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)

    def generate_signature(self, asset: Asset) -> str:
        """Generate unique signature for deduplication."""
        import hashlib

        sig_parts = [self.id, asset.id]

        # Include specified property values in signature
        for field_name in self.deduplication_signature_fields:
            value = asset.properties.get(field_name, "")
            sig_parts.append(f"{field_name}={value}")

        sig_data = ":".join(str(p) for p in sig_parts)
        return hashlib.sha256(sig_data.encode()).hexdigest()[:16]

    def can_batch_with(self, other: 'AtomicStep') -> bool:
        """Check if this step can be batched with another."""
        if not self.batch_compatible or not other.batch_compatible:
            return False

        # Must be the same step
        return self.id == other.id


@dataclass
class StepExecution:
    """Represents a queued or executing step."""
    id: str
    step_id: str
    asset_id: str
    status: StepStatus = StepStatus.PENDING

    # Execution tracking
    queued_at: datetime = field(default_factory=datetime.now)
    started_at: Optional[datetime] = None
    completed_at: Optional[datetime] = None

    # Priority and scheduling
    priority: int = 5
    scheduled_at: Optional[datetime] = None  # Delayed execution
    attempts: int = 0
    max_attempts: int = 3

    # Deduplication
    signature: str = ""

    # Results
    command_executed: str = ""
    exit_code: Optional[int] = None
    stdout: str = ""
    stderr: str = ""
    execution_time_seconds: Optional[float] = None

    # Asset updates
    created_asset_ids: List[str] = field(default_factory=list)
    updated_asset_ids: List[str] = field(default_factory=list)

    # Batch information
    batch_id: Optional[str] = None
    batched_with: List[str] = field(default_factory=list)  # Other execution IDs in batch

    # Metadata
    triggered_by: Optional[str] = None  # ID of step execution that triggered this
    parent_execution_id: Optional[str] = None
    metadata: Dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for serialization."""
        return {
            "id": self.id,
            "step_id": self.step_id,
            "asset_id": self.asset_id,
            "status": self.status.value,
            "queued_at": self.queued_at.isoformat(),
            "started_at": self.started_at.isoformat() if self.started_at else None,
            "completed_at": self.completed_at.isoformat() if self.completed_at else None,
            "priority": self.priority,
            "attempts": self.attempts,
            "signature": self.signature,
            "command_executed": self.command_executed,
            "exit_code": self.exit_code,
            "stdout": self.stdout[:500] if self.stdout else "",  # Truncate for display
            "stderr": self.stderr[:500] if self.stderr else "",
            "execution_time_seconds": self.execution_time_seconds,
            "created_asset_ids": self.created_asset_ids,
            "updated_asset_ids": self.updated_asset_ids,
            "batch_id": self.batch_id,
            "metadata": self.metadata
        }


@dataclass
class BatchExecution:
    """Represents a batch of step executions that can run together."""
    id: str
    step_id: str
    execution_ids: List[str]
    command: str
    status: StepStatus = StepStatus.PENDING
    created_at: datetime = field(default_factory=datetime.now)
    started_at: Optional[datetime] = None
    completed_at: Optional[datetime] = None

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for serialization."""
        return {
            "id": self.id,
            "step_id": self.step_id,
            "execution_ids": self.execution_ids,
            "command": self.command,
            "status": self.status.value,
            "target_count": len(self.execution_ids),
            "created_at": self.created_at.isoformat(),
            "started_at": self.started_at.isoformat() if self.started_at else None,
            "completed_at": self.completed_at.isoformat() if self.completed_at else None
        }
