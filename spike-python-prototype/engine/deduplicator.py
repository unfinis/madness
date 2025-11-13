"""Deduplication tracking to prevent redundant methodology executions."""
from typing import Dict, Set, Optional
from datetime import datetime, timedelta
from .models import TriggerMatch, DeduplicationConfig


class Deduplicator:
    """Tracks executed trigger signatures to prevent duplicates."""

    def __init__(self):
        self.executed_signatures: Dict[str, datetime] = {}
        self.execution_counts: Dict[str, int] = {}

    def should_execute(self, trigger_match: TriggerMatch, config: DeduplicationConfig) -> bool:
        """Determine if a trigger match should execute based on deduplication rules."""
        if not config.enabled:
            return True

        signature = trigger_match.signature

        # Check signature-based deduplication
        if config.strategy == "signature_based":
            if signature in self.executed_signatures:
                return False

        # Check cooldown period
        if config.cooldown_seconds and signature in self.executed_signatures:
            last_execution = self.executed_signatures[signature]
            cooldown_period = timedelta(seconds=config.cooldown_seconds)
            if datetime.now() - last_execution < cooldown_period:
                return False

        # Check max executions
        if config.max_executions:
            count = self.execution_counts.get(signature, 0)
            if count >= config.max_executions:
                return False

        return True

    def mark_executed(self, trigger_match: TriggerMatch):
        """Mark a trigger match as executed."""
        signature = trigger_match.signature
        self.executed_signatures[signature] = datetime.now()
        self.execution_counts[signature] = self.execution_counts.get(signature, 0) + 1

    def clear(self):
        """Clear all deduplication state."""
        self.executed_signatures.clear()
        self.execution_counts.clear()

    def get_stats(self) -> Dict:
        """Get deduplication statistics."""
        return {
            "total_signatures": len(self.executed_signatures),
            "total_executions": sum(self.execution_counts.values()),
            "unique_executions": len(self.execution_counts),
        }
