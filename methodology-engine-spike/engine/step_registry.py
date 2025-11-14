"""Registry for atomic steps and trigger evaluation engine."""
from typing import List, Dict, Optional, Set
from pathlib import Path
import yaml

from .atomic_steps import (
    AtomicStep, StepPhase, StepTriggerCondition,
    TriggerConditionType, CommandDefinition, OutputParser
)
from .models import Asset, AssetType
from .attack_queue import AttackQueue


class StepRegistry:
    """Registry for all atomic steps available in the system."""

    def __init__(self):
        self.steps: Dict[str, AtomicStep] = {}
        self._steps_by_phase: Dict[StepPhase, List[str]] = {}
        self._steps_by_asset_type: Dict[AssetType, List[str]] = {}

    def register_step(self, step: AtomicStep):
        """Register an atomic step.

        Args:
            step: The atomic step to register
        """
        self.steps[step.id] = step

        # Index by phase
        if step.phase not in self._steps_by_phase:
            self._steps_by_phase[step.phase] = []
        self._steps_by_phase[step.phase].append(step.id)

        # Index by asset types mentioned in triggers
        for condition in step.trigger_conditions:
            if condition.asset_type not in self._steps_by_asset_type:
                self._steps_by_asset_type[condition.asset_type] = []
            self._steps_by_asset_type[condition.asset_type].append(step.id)

    def load_steps_from_yaml(self, directory: Path):
        """Load atomic step definitions from YAML files.

        Args:
            directory: Directory containing YAML step definitions
        """
        yaml_files = list(directory.rglob("*_steps.yaml")) + list(directory.rglob("*_steps.yml"))

        for yaml_file in yaml_files:
            try:
                with open(yaml_file, 'r') as f:
                    data = yaml.safe_load(f)

                    # Handle single step or list of steps
                    steps_data = data if isinstance(data, list) else [data]

                    for step_data in steps_data:
                        step = self._parse_step_yaml(step_data)
                        self.register_step(step)
                        print(f"Loaded step: {step.name}")
            except Exception as e:
                print(f"Error loading {yaml_file}: {e}")

    def _parse_step_yaml(self, data: Dict) -> AtomicStep:
        """Parse a step definition from YAML data."""
        # Parse trigger conditions
        trigger_conditions = []
        for cond_data in data.get("trigger_conditions", []):
            condition = StepTriggerCondition(
                condition_type=TriggerConditionType[cond_data["condition_type"].upper()],
                asset_type=AssetType[cond_data["asset_type"].upper()],
                property_name=cond_data.get("property_name"),
                property_value=cond_data.get("property_value"),
                property_pattern=cond_data.get("property_pattern")
            )
            trigger_conditions.append(condition)

        # Parse commands
        commands = []
        for cmd_data in data.get("commands", []):
            command = CommandDefinition(
                tool=cmd_data["tool"],
                command=cmd_data["command"],
                platforms=cmd_data.get("platforms", ["linux", "macos", "windows"]),
                timeout=cmd_data.get("timeout", 300),
                preferred=cmd_data.get("preferred", True),
                requires_elevation=cmd_data.get("requires_elevation", False),
                notes=cmd_data.get("notes", "")
            )
            commands.append(command)

        # Parse output parser if present
        output_parser = None
        if "output_parser" in data:
            parser_data = data["output_parser"]
            output_parser = OutputParser(
                parser_type=parser_data.get("parser_type", "regex"),
                patterns=parser_data.get("patterns", {}),
                creates_assets=parser_data.get("creates_assets", []),
                updates_asset=parser_data.get("updates_asset", {})
            )

        return AtomicStep(
            id=data["id"],
            name=data["name"],
            description=data.get("description", ""),
            phase=StepPhase[data["phase"].upper()],
            trigger_conditions=trigger_conditions,
            prerequisites=data.get("prerequisites", []),
            commands=commands,
            priority=data.get("priority", 5),
            timeout_seconds=data.get("timeout_seconds", 300),
            output_parser=output_parser,
            next_step_ids=data.get("next_step_ids", []),
            failure_step_ids=data.get("failure_step_ids", []),
            deduplication_signature_fields=data.get("deduplication_signature_fields", []),
            cooldown_seconds=data.get("cooldown_seconds"),
            batch_compatible=data.get("batch_compatible", False),
            max_batch_size=data.get("max_batch_size", 100),
            tags=data.get("tags", []),
            metadata=data.get("metadata", {})
        )

    def get_step(self, step_id: str) -> Optional[AtomicStep]:
        """Get a step by ID."""
        return self.steps.get(step_id)

    def get_steps_by_phase(self, phase: StepPhase) -> List[AtomicStep]:
        """Get all steps for a specific phase."""
        step_ids = self._steps_by_phase.get(phase, [])
        return [self.steps[sid] for sid in step_ids]

    def get_steps_for_asset_type(self, asset_type: AssetType) -> List[AtomicStep]:
        """Get all steps that can trigger for an asset type."""
        step_ids = self._steps_by_asset_type.get(asset_type, [])
        return [self.steps[sid] for sid in step_ids]

    def get_stats(self) -> Dict:
        """Get registry statistics."""
        return {
            "total_steps": len(self.steps),
            "steps_by_phase": {
                phase.value: len(step_ids)
                for phase, step_ids in self._steps_by_phase.items()
            },
            "steps_by_asset_type": {
                asset_type.value: len(step_ids)
                for asset_type, step_ids in self._steps_by_asset_type.items()
            }
        }


class TriggerEngine:
    """Engine that evaluates asset changes and triggers appropriate steps."""

    def __init__(self, step_registry: StepRegistry, attack_queue: AttackQueue):
        self.step_registry = step_registry
        self.attack_queue = attack_queue

        # Track asset states for change detection
        self._asset_snapshots: Dict[str, Dict] = {}

    def evaluate_asset_created(self, asset: Asset) -> List[str]:
        """Evaluate triggers when a new asset is created.

        Args:
            asset: The newly created asset

        Returns:
            List of execution IDs that were queued
        """
        queued_execution_ids = []

        # Get potential steps for this asset type
        candidate_steps = self.step_registry.get_steps_for_asset_type(asset.type)

        for step in candidate_steps:
            # Check each trigger condition
            for condition in step.trigger_conditions:
                if condition.condition_type == TriggerConditionType.ASSET_CREATED:
                    if condition.matches(asset):
                        # Queue the step
                        execution = self.attack_queue.enqueue(step, asset)
                        if execution:
                            queued_execution_ids.append(execution.id)
                        break  # Only trigger once per step

        # Save snapshot for future change detection
        self._asset_snapshots[asset.id] = dict(asset.properties)

        return queued_execution_ids

    def evaluate_asset_updated(
        self,
        asset: Asset,
        changed_properties: Optional[Set[str]] = None
    ) -> List[str]:
        """Evaluate triggers when an asset is updated.

        Args:
            asset: The updated asset
            changed_properties: Set of property names that changed

        Returns:
            List of execution IDs that were queued
        """
        queued_execution_ids = []

        # Detect changed properties if not provided
        if changed_properties is None:
            changed_properties = self._detect_changed_properties(asset)

        # Get potential steps for this asset type
        candidate_steps = self.step_registry.get_steps_for_asset_type(asset.type)

        for step in candidate_steps:
            for condition in step.trigger_conditions:
                # Check various trigger types
                should_trigger = False

                if condition.condition_type == TriggerConditionType.PROPERTY_SET:
                    if condition.property_name in changed_properties:
                        if condition.matches(asset, condition.property_name):
                            should_trigger = True

                elif condition.condition_type == TriggerConditionType.PROPERTY_UPDATED:
                    if condition.property_name in changed_properties:
                        if condition.matches(asset, condition.property_name):
                            should_trigger = True

                elif condition.condition_type == TriggerConditionType.PROPERTY_MATCH:
                    if condition.matches(asset):
                        should_trigger = True

                elif condition.condition_type == TriggerConditionType.PROPERTY_NULL:
                    if condition.matches(asset):
                        should_trigger = True

                elif condition.condition_type == TriggerConditionType.PROPERTY_NOT_NULL:
                    if condition.property_name in changed_properties:
                        if condition.matches(asset):
                            should_trigger = True

                if should_trigger:
                    # Queue the step
                    execution = self.attack_queue.enqueue(step, asset)
                    if execution:
                        queued_execution_ids.append(execution.id)
                    break  # Only trigger once per step

        # Update snapshot
        self._asset_snapshots[asset.id] = dict(asset.properties)

        return queued_execution_ids

    def _detect_changed_properties(self, asset: Asset) -> Set[str]:
        """Detect which properties changed since last snapshot.

        Args:
            asset: The asset to check

        Returns:
            Set of property names that changed
        """
        changed = set()

        if asset.id not in self._asset_snapshots:
            # All properties are "new"
            return set(asset.properties.keys())

        old_props = self._asset_snapshots[asset.id]
        new_props = asset.properties

        # Find changed properties
        for key in set(old_props.keys()) | set(new_props.keys()):
            old_value = old_props.get(key)
            new_value = new_props.get(key)

            if old_value != new_value:
                changed.add(key)

        return changed

    def chain_next_steps(
        self,
        completed_execution_id: str,
        step_id: str,
        asset: Asset,
        success: bool = True
    ) -> List[str]:
        """Queue next steps in a chain after a step completes.

        Args:
            completed_execution_id: ID of the completed execution
            step_id: ID of the step that completed
            asset: Asset the step operated on
            success: Whether the step succeeded

        Returns:
            List of execution IDs that were queued
        """
        queued_execution_ids = []

        step = self.step_registry.get_step(step_id)
        if not step:
            return queued_execution_ids

        # Determine which next steps to queue
        next_step_ids = step.next_step_ids if success else step.failure_step_ids

        for next_step_id in next_step_ids:
            next_step = self.step_registry.get_step(next_step_id)
            if next_step:
                # Queue with slight priority boost (run sooner)
                execution = self.attack_queue.enqueue(
                    next_step,
                    asset,
                    triggered_by=completed_execution_id,
                    priority_boost=-1  # Higher priority
                )
                if execution:
                    queued_execution_ids.append(execution.id)

        return queued_execution_ids

    def get_stats(self) -> Dict:
        """Get trigger engine statistics."""
        return {
            "tracked_assets": len(self._asset_snapshots),
            "queue_stats": self.attack_queue.get_stats(),
            "registry_stats": self.step_registry.get_stats()
        }
