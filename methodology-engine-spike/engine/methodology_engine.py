"""Main methodology engine orchestrator."""
from typing import List, Dict, Optional
import yaml
from pathlib import Path
from .models import (
    Asset, Methodology, TriggerMatch, BatchCommand,
    Trigger, TriggerType, AssetType, DeduplicationConfig,
    MethodologyStep, CommandAlternative, AssetRelationship, RelationshipType
)
from .trigger_matcher import TriggerMatcher
from .batch_generator import BatchGenerator
from .deduplicator import Deduplicator
from .relationship_manager import RelationshipManager


class MethodologyEngine:
    """Main engine coordinating trigger matching, deduplication, and batch generation."""

    def __init__(self):
        self.assets: List[Asset] = []
        self.methodologies: Dict[str, Methodology] = {}
        self.deduplicator = Deduplicator()
        self.trigger_matcher = TriggerMatcher(self.deduplicator)
        self.batch_generator = BatchGenerator()
        self.trigger_matches: List[TriggerMatch] = []
        self.batch_commands: List[BatchCommand] = []
        self.relationship_manager = RelationshipManager()

    def load_methodologies_from_yaml(self, directory: Path):
        """Load methodology definitions from YAML files."""
        yaml_files = list(directory.rglob("*.yaml")) + list(directory.rglob("*.yml"))

        for yaml_file in yaml_files:
            try:
                with open(yaml_file, 'r') as f:
                    data = yaml.safe_load(f)
                    methodology = self._parse_methodology_yaml(data)
                    self.methodologies[methodology.id] = methodology
                    print(f"Loaded methodology: {methodology.name}")
            except Exception as e:
                print(f"Error loading {yaml_file}: {e}")

    def _parse_methodology_yaml(self, data: Dict) -> Methodology:
        """Parse a methodology from YAML data."""
        # Parse triggers
        triggers = []
        for trigger_data in data.get("triggers", []):
            trigger = Trigger(
                id=trigger_data["id"],
                type=TriggerType[trigger_data["type"].upper()],
                asset_type=AssetType[trigger_data["asset_type"].upper()] if "asset_type" in trigger_data else None,
                required_properties=trigger_data.get("required_properties", {}),
                required_count=trigger_data.get("required_count", 1),
                priority=trigger_data.get("priority", 5),
                description=trigger_data.get("description", ""),
                deduplication=DeduplicationConfig(
                    enabled=trigger_data.get("deduplication", {}).get("enabled", True),
                    strategy=trigger_data.get("deduplication", {}).get("strategy", "signature_based"),
                    signature_fields=trigger_data.get("deduplication", {}).get("signature_fields", []),
                    cooldown_seconds=trigger_data.get("deduplication", {}).get("cooldown_seconds"),
                    max_executions=trigger_data.get("deduplication", {}).get("max_executions")
                )
            )
            triggers.append(trigger)

        # Parse steps
        steps = []
        for idx, step_data in enumerate(data.get("steps", [])):
            # Parse command alternatives if present (new format)
            command_alternatives = []
            if "commands" in step_data:
                for cmd_data in step_data["commands"]:
                    cmd_alt = CommandAlternative(
                        tool=cmd_data["tool"],
                        platforms=cmd_data.get("platforms", ["any"]),
                        command=cmd_data["command"],
                        preferred=cmd_data.get("preferred", False),
                        notes=cmd_data.get("notes", ""),
                        requires_elevation=cmd_data.get("requires_elevation", False)
                    )
                    command_alternatives.append(cmd_alt)

            step = MethodologyStep(
                id=step_data.get("id", f"step_{idx}"),
                name=step_data["name"],
                description=step_data.get("description", ""),
                command_template=step_data.get("command", ""),  # Legacy format (optional now)
                commands=command_alternatives,  # New format
                order=step_data.get("order", idx),
                timeout_seconds=step_data.get("timeout_seconds"),
                expected_outputs=step_data.get("expected_outputs", []),
                asset_discovery_patterns=step_data.get("asset_discovery_patterns", [])
            )
            steps.append(step)

        return Methodology(
            id=data["id"],
            name=data["name"],
            description=data.get("description", ""),
            category=data.get("category", "reconnaissance"),
            risk_level=data.get("risk_level", "medium"),
            triggers=triggers,
            steps=steps,
            batch_compatible=data.get("batch_compatible", True),
            metadata=data.get("metadata", {})
        )

    def add_asset(self, asset: Asset) -> List[TriggerMatch]:
        """Add a new asset and evaluate triggers."""
        self.assets.append(asset)

        # Register with relationship manager
        self.relationship_manager.add_asset(asset)

        # Evaluate what triggers fire
        new_matches = self.trigger_matcher.evaluate_new_asset(
            asset,
            [a for a in self.assets if a.id != asset.id],
            list(self.methodologies.values())
        )

        # Add new matches
        self.trigger_matches.extend(new_matches)

        # Generate batch commands for new matches
        if new_matches:
            new_batches = self.batch_generator.generate_batches(
                new_matches,
                self.methodologies
            )
            self.batch_commands.extend(new_batches)

            # Mark matches as executed
            for match in new_matches:
                self.deduplicator.mark_executed(match)
                match.executed = True

        return new_matches

    def get_pending_commands(self) -> List[BatchCommand]:
        """Get all generated batch commands."""
        return self.batch_commands

    def get_assets(self) -> List[Asset]:
        """Get all assets."""
        return self.assets

    def get_methodologies(self) -> List[Methodology]:
        """Get all loaded methodologies."""
        return list(self.methodologies.values())

    def get_trigger_matches(self) -> List[TriggerMatch]:
        """Get all trigger matches."""
        return self.trigger_matches

    def get_stats(self) -> Dict:
        """Get engine statistics."""
        return {
            "total_assets": len(self.assets),
            "total_methodologies": len(self.methodologies),
            "total_trigger_matches": len(self.trigger_matches),
            "total_batch_commands": len(self.batch_commands),
            "pending_commands": len([c for c in self.batch_commands if not any(m.executed for m in c.trigger_matches)]),
            "deduplication_stats": self.deduplicator.get_stats(),
            "assets_by_type": self._count_assets_by_type(),
            "relationship_stats": self.relationship_manager.get_stats(),
        }

    def _count_assets_by_type(self) -> Dict[str, int]:
        """Count assets by type."""
        counts = {}
        for asset in self.assets:
            type_name = asset.type.value
            counts[type_name] = counts.get(type_name, 0) + 1
        return counts

    def add_relationship(self, relationship: AssetRelationship):
        """Add a relationship between two assets."""
        self.relationship_manager.add_relationship(relationship)

    def get_relationships(
        self,
        asset_id: Optional[str] = None,
        relationship_type: Optional[RelationshipType] = None
    ) -> List[AssetRelationship]:
        """Get relationships, optionally filtered by asset and type."""
        return self.relationship_manager.get_relationships(asset_id, relationship_type)

    def get_related_assets(
        self,
        asset_id: str,
        relationship_type: Optional[RelationshipType] = None
    ) -> List[Asset]:
        """Get assets related to the given asset."""
        return self.relationship_manager.get_related_assets(asset_id, relationship_type)

    def find_pivot_paths(self, from_asset_id: str, to_network_cidr: str) -> List[List[Asset]]:
        """Find all pivot paths from a compromised host to a target network."""
        return self.relationship_manager.find_pivot_paths(from_asset_id, to_network_cidr)

    def get_compromise_candidates(self) -> List[Dict]:
        """Identify high-value compromise candidates based on relationships."""
        return self.relationship_manager.get_compromise_candidates()

    def clear(self):
        """Clear all state."""
        self.assets.clear()
        self.trigger_matches.clear()
        self.batch_commands.clear()
        self.deduplicator.clear()
        self.relationship_manager.clear()
