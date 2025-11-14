"""Atomic step-based methodology engine - next generation attack queue."""
from typing import List, Dict, Optional, Set
from pathlib import Path
import uuid

from .models import Asset, AssetType
from .atomic_steps import AtomicStep, StepExecution, StepStatus
from .attack_queue import AttackQueue
from .step_registry import StepRegistry, TriggerEngine


class AtomicMethodologyEngine:
    """Next-generation methodology engine using atomic steps and attack queue.

    This engine provides:
    - Atomic, state-driven step execution
    - Priority-based attack queue
    - Automatic trigger evaluation on asset changes
    - Intelligent batching of similar operations
    - Granular progress tracking
    """

    def __init__(self):
        # Core components
        self.assets: Dict[str, Asset] = {}
        self.step_registry = StepRegistry()
        self.attack_queue = AttackQueue()
        self.trigger_engine = TriggerEngine(self.step_registry, self.attack_queue)

        # Execution tracking
        self.completed_executions: List[str] = []

    def load_steps_from_directory(self, directory: Path):
        """Load atomic step definitions from a directory.

        Args:
            directory: Directory containing step YAML files
        """
        self.step_registry.load_steps_from_yaml(directory)
        print(f"Loaded {len(self.step_registry.steps)} atomic steps")

    def register_step(self, step: AtomicStep):
        """Register a single atomic step.

        Args:
            step: The atomic step to register
        """
        self.step_registry.register_step(step)

    def add_asset(self, asset: Asset) -> List[str]:
        """Add a new asset to the system.

        This will:
        1. Store the asset
        2. Evaluate triggers
        3. Queue appropriate steps

        Args:
            asset: The asset to add

        Returns:
            List of execution IDs that were queued
        """
        # Store asset
        self.assets[asset.id] = asset

        # Trigger evaluation
        execution_ids = self.trigger_engine.evaluate_asset_created(asset)

        return execution_ids

    def update_asset(
        self,
        asset_id: str,
        properties: Dict,
        merge: bool = True
    ) -> List[str]:
        """Update an asset's properties.

        This will:
        1. Update the asset
        2. Detect changed properties
        3. Evaluate triggers
        4. Queue appropriate steps

        Args:
            asset_id: ID of the asset to update
            properties: New property values
            merge: If True, merge with existing properties; if False, replace

        Returns:
            List of execution IDs that were queued
        """
        if asset_id not in self.assets:
            raise ValueError(f"Asset {asset_id} not found")

        asset = self.assets[asset_id]
        old_properties = set(asset.properties.keys())

        # Update properties
        if merge:
            asset.properties.update(properties)
        else:
            asset.properties = dict(properties)

        # Detect changes
        new_properties = set(asset.properties.keys())
        changed_properties = set()

        # Check for new or modified properties
        for key in new_properties:
            if key not in old_properties or properties.get(key) != asset.properties.get(key):
                changed_properties.add(key)

        # Trigger evaluation
        execution_ids = self.trigger_engine.evaluate_asset_updated(asset, changed_properties)

        return execution_ids

    def get_next_execution(self, respect_batch_window: bool = True) -> Optional[StepExecution]:
        """Get the next step execution to run.

        Args:
            respect_batch_window: Wait for batch window before dequeuing

        Returns:
            StepExecution to run, or None if queue is empty
        """
        executions = self.attack_queue.dequeue(count=1, respect_batch_window=respect_batch_window)
        return executions[0] if executions else None

    def get_next_batch(
        self,
        max_size: int = 100,
        respect_batch_window: bool = True
    ) -> List[StepExecution]:
        """Get a batch of executions to run together.

        Args:
            max_size: Maximum batch size
            respect_batch_window: Wait for batch window before dequeuing

        Returns:
            List of executions to run in batch
        """
        executions = self.attack_queue.dequeue(count=max_size, respect_batch_window=respect_batch_window)

        # Group by step_id
        by_step = {}
        for exec in executions:
            if exec.step_id not in by_step:
                by_step[exec.step_id] = []
            by_step[exec.step_id].append(exec)

        # Return largest batchable group
        if by_step:
            step_id = max(by_step.keys(), key=lambda k: len(by_step[k]))
            return by_step[step_id]

        return []

    def mark_execution_completed(
        self,
        execution_id: str,
        exit_code: int,
        stdout: str = "",
        stderr: str = "",
        created_assets: List[Asset] = None,
        updated_asset_ids: List[str] = None
    ):
        """Mark a step execution as completed.

        This will:
        1. Update execution status
        2. Process any newly created assets
        3. Update any modified assets
        4. Chain to next steps if configured

        Args:
            execution_id: ID of the execution
            exit_code: Exit code from command
            stdout: Standard output
            stderr: Standard error
            created_assets: Newly created assets from this step
            updated_asset_ids: IDs of assets that were updated
        """
        execution = self.attack_queue.executions.get(execution_id)
        if not execution:
            return

        # Process created assets
        created_asset_ids = []
        if created_assets:
            for asset in created_assets:
                self.assets[asset.id] = asset
                created_asset_ids.append(asset.id)

                # Trigger evaluation for new asset
                self.trigger_engine.evaluate_asset_created(asset)

        # Process updated assets
        if updated_asset_ids:
            for asset_id in updated_asset_ids:
                if asset_id in self.assets:
                    asset = self.assets[asset_id]
                    # Trigger evaluation for updated asset
                    self.trigger_engine.evaluate_asset_updated(asset)

        # Mark as completed
        self.attack_queue.mark_completed(
            execution_id,
            exit_code,
            stdout,
            stderr,
            created_asset_ids,
            updated_asset_ids or []
        )

        # Chain to next steps
        if exit_code == 0:  # Success
            asset = self.assets.get(execution.asset_id)
            if asset:
                self.trigger_engine.chain_next_steps(
                    execution_id,
                    execution.step_id,
                    asset,
                    success=True
                )

        self.completed_executions.append(execution_id)

    def mark_execution_failed(self, execution_id: str, error: str, should_retry: bool = True):
        """Mark a step execution as failed.

        Args:
            execution_id: ID of the execution
            error: Error message
            should_retry: Whether to retry
        """
        self.attack_queue.mark_failed(execution_id, error, should_retry)

    def get_asset(self, asset_id: str) -> Optional[Asset]:
        """Get an asset by ID."""
        return self.assets.get(asset_id)

    def get_assets_by_type(self, asset_type: AssetType) -> List[Asset]:
        """Get all assets of a specific type."""
        return [a for a in self.assets.values() if a.type == asset_type]

    def get_pending_executions(self) -> List[StepExecution]:
        """Get all pending step executions."""
        return self.attack_queue.get_executions_by_status(StepStatus.PENDING)

    def get_in_progress_executions(self) -> List[StepExecution]:
        """Get all in-progress step executions."""
        return self.attack_queue.get_executions_by_status(StepStatus.IN_PROGRESS)

    def get_completed_executions(self) -> List[StepExecution]:
        """Get all completed step executions."""
        return self.attack_queue.get_executions_by_status(StepStatus.COMPLETED)

    def get_executions_for_asset(self, asset_id: str) -> List[StepExecution]:
        """Get all executions for a specific asset."""
        return self.attack_queue.get_executions_by_asset(asset_id)

    def peek_queue(self, count: int = 10) -> List[StepExecution]:
        """Peek at upcoming executions without removing them.

        Args:
            count: Number of executions to peek at

        Returns:
            List of upcoming executions
        """
        return self.attack_queue.peek(count)

    def get_stats(self) -> Dict:
        """Get comprehensive engine statistics."""
        return {
            "assets": {
                "total": len(self.assets),
                "by_type": self._count_assets_by_type()
            },
            "steps": self.step_registry.get_stats(),
            "queue": self.attack_queue.get_stats(),
            "trigger_engine": self.trigger_engine.get_stats(),
            "executions": {
                "total": len(self.attack_queue.executions),
                "completed": len(self.completed_executions),
                "pending": self.attack_queue.get_pending_count(),
                "in_progress": self.attack_queue.get_in_progress_count()
            }
        }

    def _count_assets_by_type(self) -> Dict[str, int]:
        """Count assets by type."""
        counts = {}
        for asset in self.assets.values():
            type_name = asset.type.value
            counts[type_name] = counts.get(type_name, 0) + 1
        return counts

    def clear(self):
        """Clear all state."""
        self.assets.clear()
        self.completed_executions.clear()
        # Note: We don't clear step_registry as those are definitions, not state


# Convenience function to create a basic asset
def create_asset(
    asset_type: AssetType,
    name: str,
    properties: Dict = None,
    asset_id: Optional[str] = None
) -> Asset:
    """Create an asset with common defaults.

    Args:
        asset_type: Type of asset
        name: Asset name
        properties: Asset properties
        asset_id: Asset ID (generated if not provided)

    Returns:
        Asset object
    """
    return Asset(
        id=asset_id or str(uuid.uuid4()),
        type=asset_type,
        name=name,
        properties=properties or {}
    )
