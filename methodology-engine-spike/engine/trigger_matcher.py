"""Trigger matching logic to determine which methodologies should execute."""
from typing import List, Dict
from .models import Asset, Methodology, Trigger, TriggerMatch, DeduplicationConfig
from .deduplicator import Deduplicator


class TriggerMatcher:
    """Evaluates triggers against assets to find methodology matches."""

    def __init__(self, deduplicator: Deduplicator):
        self.deduplicator = deduplicator

    def evaluate_methodologies(
        self,
        assets: List[Asset],
        methodologies: List[Methodology]
    ) -> List[TriggerMatch]:
        """Evaluate all methodologies against current assets."""
        matches = []

        for methodology in methodologies:
            methodology_matches = self.evaluate_methodology(assets, methodology)
            matches.extend(methodology_matches)

        # Sort by priority (lower number = higher priority)
        matches.sort(key=lambda m: m.priority)

        return matches

    def evaluate_methodology(
        self,
        assets: List[Asset],
        methodology: Methodology
    ) -> List[TriggerMatch]:
        """Evaluate a single methodology's triggers against assets."""
        matches = []

        for trigger in methodology.triggers:
            if trigger.matches(assets):
                # Get the specific assets that matched
                matched_assets = trigger.get_matching_assets(assets)

                # Generate deduplication signature
                signature = trigger.deduplication.generate_signature(
                    matched_assets,
                    methodology.id
                )

                # Calculate confidence based on asset confidence scores
                avg_confidence = sum(a.confidence for a in matched_assets) / len(matched_assets)

                # Create trigger match
                trigger_match = TriggerMatch(
                    trigger_id=trigger.id,
                    methodology_id=methodology.id,
                    matched_assets=matched_assets,
                    priority=trigger.priority,
                    confidence=avg_confidence,
                    signature=signature
                )

                # Check deduplication
                if self.deduplicator.should_execute(trigger_match, trigger.deduplication):
                    matches.append(trigger_match)

        return matches

    def evaluate_new_asset(
        self,
        new_asset: Asset,
        existing_assets: List[Asset],
        methodologies: List[Methodology]
    ) -> List[TriggerMatch]:
        """Evaluate what triggers fire when a new asset is added."""
        # Combine with existing assets
        all_assets = existing_assets + [new_asset]

        # Find new matches
        return self.evaluate_methodologies(all_assets, methodologies)
