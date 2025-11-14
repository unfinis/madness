"""Priority-based attack queue for managing step executions."""
from typing import List, Dict, Optional, Set
from datetime import datetime, timedelta
import heapq
import uuid
from collections import defaultdict

from .atomic_steps import (
    AtomicStep, StepExecution, BatchExecution,
    StepStatus, TriggerConditionType
)
from .models import Asset, AssetType


class AttackQueue:
    """Priority-based queue for managing atomic step executions."""

    def __init__(self):
        # Priority queue: (priority, timestamp, execution)
        # Lower priority number = higher urgency
        self._queue: List[tuple] = []
        self._execution_counter = 0

        # Lookup tables
        self.executions: Dict[str, StepExecution] = {}  # execution_id -> StepExecution
        self.batches: Dict[str, BatchExecution] = {}    # batch_id -> BatchExecution
        self.executed_signatures: Set[str] = set()      # For deduplication

        # Index for fast lookups
        self._executions_by_step: Dict[str, List[str]] = defaultdict(list)  # step_id -> execution_ids
        self._executions_by_asset: Dict[str, List[str]] = defaultdict(list)  # asset_id -> execution_ids
        self._executions_by_status: Dict[StepStatus, List[str]] = defaultdict(list)

        # Batch window - collect similar steps for batching
        self.batch_window_seconds = 5
        self._pending_batch_window: Dict[str, datetime] = {}  # step_id -> window_start_time

    def enqueue(
        self,
        step: AtomicStep,
        asset: Asset,
        triggered_by: Optional[str] = None,
        priority_boost: int = 0
    ) -> Optional[StepExecution]:
        """Add a step execution to the queue.

        Args:
            step: The atomic step to execute
            asset: The asset this step operates on
            triggered_by: ID of step execution that triggered this (for chaining)
            priority_boost: Additional priority boost (negative = higher priority)

        Returns:
            StepExecution if queued, None if deduplicated
        """
        # Generate signature for deduplication
        signature = step.generate_signature(asset)

        # Check if already executed (with cooldown)
        if signature in self.executed_signatures:
            # TODO: Implement cooldown logic
            return None

        # Create execution record
        execution = StepExecution(
            id=str(uuid.uuid4()),
            step_id=step.id,
            asset_id=asset.id,
            status=StepStatus.PENDING,
            priority=step.priority + priority_boost,
            signature=signature,
            triggered_by=triggered_by,
            metadata={
                "step_name": step.name,
                "step_phase": step.phase.value,
                "asset_type": asset.type.value,
                "asset_name": asset.name
            }
        )

        # Add to queue (priority, counter for FIFO, execution)
        # Negative priority because heapq is a min-heap
        heapq.heappush(
            self._queue,
            (execution.priority, self._execution_counter, execution)
        )
        self._execution_counter += 1

        # Update indexes
        self.executions[execution.id] = execution
        self._executions_by_step[step.id].append(execution.id)
        self._executions_by_asset[asset.id].append(execution.id)
        self._executions_by_status[StepStatus.PENDING].append(execution.id)

        # Track batch window if batch compatible
        if step.batch_compatible:
            if step.id not in self._pending_batch_window:
                self._pending_batch_window[step.id] = datetime.now()

        return execution

    def dequeue(self, count: int = 1, respect_batch_window: bool = True) -> List[StepExecution]:
        """Get next step(s) to execute from the queue.

        Args:
            count: Maximum number of executions to dequeue
            respect_batch_window: Wait for batch window to collect similar steps

        Returns:
            List of StepExecution objects ready to run
        """
        if not self._queue:
            return []

        # Check if we should wait for batching
        if respect_batch_window:
            # Peek at next item
            priority, _, next_exec = self._queue[0]
            step_id = next_exec.step_id

            # If step is batch compatible and window not expired, wait
            if step_id in self._pending_batch_window:
                window_start = self._pending_batch_window[step_id]
                elapsed = (datetime.now() - window_start).total_seconds()

                if elapsed < self.batch_window_seconds:
                    # Check if we have more pending items for same step
                    pending_count = len([
                        e for e in self._executions_by_step[step_id]
                        if self.executions[e].status == StepStatus.PENDING
                    ])

                    if pending_count > 1:
                        # Wait for more items to batch
                        return []

        # Dequeue up to count items
        ready = []
        while len(ready) < count and self._queue:
            priority, counter, execution = heapq.heappop(self._queue)

            # Update status
            execution.status = StepStatus.IN_PROGRESS
            execution.started_at = datetime.now()

            # Update indexes
            self._executions_by_status[StepStatus.PENDING].remove(execution.id)
            self._executions_by_status[StepStatus.IN_PROGRESS].append(execution.id)

            ready.append(execution)

        # Clear batch window for dequeued steps
        for exec in ready:
            if exec.step_id in self._pending_batch_window:
                del self._pending_batch_window[exec.step_id]

        return ready

    def mark_completed(
        self,
        execution_id: str,
        exit_code: int,
        stdout: str = "",
        stderr: str = "",
        created_assets: List[str] = None,
        updated_assets: List[str] = None
    ):
        """Mark a step execution as completed.

        Args:
            execution_id: ID of the execution
            exit_code: Exit code from command
            stdout: Standard output
            stderr: Standard error
            created_assets: IDs of newly created assets
            updated_assets: IDs of updated assets
        """
        if execution_id not in self.executions:
            return

        execution = self.executions[execution_id]
        execution.status = StepStatus.COMPLETED if exit_code == 0 else StepStatus.FAILED
        execution.completed_at = datetime.now()
        execution.exit_code = exit_code
        execution.stdout = stdout
        execution.stderr = stderr
        execution.created_asset_ids = created_assets or []
        execution.updated_asset_ids = updated_assets or []

        if execution.started_at:
            execution.execution_time_seconds = (
                execution.completed_at - execution.started_at
            ).total_seconds()

        # Update indexes
        self._executions_by_status[StepStatus.IN_PROGRESS].remove(execution_id)
        self._executions_by_status[execution.status].append(execution_id)

        # Mark signature as executed
        self.executed_signatures.add(execution.signature)

    def mark_failed(
        self,
        execution_id: str,
        error: str,
        should_retry: bool = True
    ):
        """Mark a step execution as failed.

        Args:
            execution_id: ID of the execution
            error: Error message
            should_retry: Whether to retry the execution
        """
        if execution_id not in self.executions:
            return

        execution = self.executions[execution_id]
        execution.attempts += 1

        if should_retry and execution.attempts < execution.max_attempts:
            # Re-queue with lower priority (higher number = lower priority)
            execution.status = StepStatus.PENDING
            execution.priority += 2  # Lower priority on retry

            heapq.heappush(
                self._queue,
                (execution.priority, self._execution_counter, execution)
            )
            self._execution_counter += 1
        else:
            # Mark as permanently failed
            execution.status = StepStatus.FAILED
            execution.completed_at = datetime.now()
            execution.stderr = error

            self._executions_by_status[StepStatus.FAILED].append(execution_id)

        # Remove from in_progress
        if execution_id in self._executions_by_status[StepStatus.IN_PROGRESS]:
            self._executions_by_status[StepStatus.IN_PROGRESS].remove(execution_id)

    def get_pending_count(self) -> int:
        """Get count of pending executions."""
        return len([e for _, _, e in self._queue if e.status == StepStatus.PENDING])

    def get_in_progress_count(self) -> int:
        """Get count of in-progress executions."""
        return len(self._executions_by_status[StepStatus.IN_PROGRESS])

    def get_batchable_executions(self, step_id: str) -> List[StepExecution]:
        """Get all pending executions for a step that can be batched.

        Args:
            step_id: ID of the atomic step

        Returns:
            List of pending executions for this step
        """
        execution_ids = self._executions_by_step.get(step_id, [])
        pending = []

        for exec_id in execution_ids:
            execution = self.executions.get(exec_id)
            if execution and execution.status == StepStatus.PENDING:
                pending.append(execution)

        return pending

    def create_batch(
        self,
        step_id: str,
        execution_ids: List[str],
        batch_command: str
    ) -> BatchExecution:
        """Create a batch execution from multiple individual executions.

        Args:
            step_id: ID of the atomic step
            execution_ids: List of execution IDs to batch
            batch_command: Combined batch command

        Returns:
            BatchExecution object
        """
        batch = BatchExecution(
            id=str(uuid.uuid4()),
            step_id=step_id,
            execution_ids=execution_ids,
            command=batch_command
        )

        self.batches[batch.id] = batch

        # Mark executions as batched
        for exec_id in execution_ids:
            if exec_id in self.executions:
                self.executions[exec_id].batch_id = batch.id
                self.executions[exec_id].batched_with = [
                    e for e in execution_ids if e != exec_id
                ]

        return batch

    def get_stats(self) -> Dict:
        """Get queue statistics."""
        return {
            "total_executions": len(self.executions),
            "pending": len(self._executions_by_status[StepStatus.PENDING]),
            "in_progress": len(self._executions_by_status[StepStatus.IN_PROGRESS]),
            "completed": len(self._executions_by_status[StepStatus.COMPLETED]),
            "failed": len(self._executions_by_status[StepStatus.FAILED]),
            "skipped": len(self._executions_by_status[StepStatus.SKIPPED]),
            "batches": len(self.batches),
            "queue_depth": len(self._queue),
            "executed_signatures": len(self.executed_signatures)
        }

    def get_executions_by_asset(self, asset_id: str) -> List[StepExecution]:
        """Get all executions for a specific asset."""
        execution_ids = self._executions_by_asset.get(asset_id, [])
        return [self.executions[eid] for eid in execution_ids if eid in self.executions]

    def get_executions_by_status(self, status: StepStatus) -> List[StepExecution]:
        """Get all executions with a specific status."""
        execution_ids = self._executions_by_status.get(status, [])
        return [self.executions[eid] for eid in execution_ids if eid in self.executions]

    def clear_completed(self, older_than_hours: int = 24):
        """Clear completed executions older than specified hours.

        Args:
            older_than_hours: Remove completed executions older than this
        """
        cutoff = datetime.now() - timedelta(hours=older_than_hours)
        to_remove = []

        for exec_id, execution in self.executions.items():
            if execution.status in [StepStatus.COMPLETED, StepStatus.FAILED]:
                if execution.completed_at and execution.completed_at < cutoff:
                    to_remove.append(exec_id)

        for exec_id in to_remove:
            execution = self.executions[exec_id]

            # Remove from indexes
            self._executions_by_step[execution.step_id].remove(exec_id)
            self._executions_by_asset[execution.asset_id].remove(exec_id)
            self._executions_by_status[execution.status].remove(exec_id)

            # Remove execution
            del self.executions[exec_id]

    def peek(self, count: int = 10) -> List[StepExecution]:
        """Peek at next items in queue without removing them.

        Args:
            count: Number of items to peek at

        Returns:
            List of upcoming executions (not removed from queue)
        """
        # Create a copy of queue and peek
        peeked = []
        temp_queue = list(self._queue)
        heapq.heapify(temp_queue)

        for _ in range(min(count, len(temp_queue))):
            if temp_queue:
                _, _, execution = heapq.heappop(temp_queue)
                peeked.append(execution)

        return peeked
