"""Intelligent batch command generation from multiple trigger matches."""
from typing import List, Dict
import uuid
from .models import TriggerMatch, BatchCommand, Methodology, MethodologyStep


class BatchGenerator:
    """Generates efficient batch commands from multiple trigger matches."""

    def generate_batches(
        self,
        trigger_matches: List[TriggerMatch],
        methodologies: Dict[str, Methodology]
    ) -> List[BatchCommand]:
        """Generate batch commands from trigger matches."""
        batches = []

        # Group trigger matches by methodology
        by_methodology: Dict[str, List[TriggerMatch]] = {}
        for match in trigger_matches:
            if match.methodology_id not in by_methodology:
                by_methodology[match.methodology_id] = []
            by_methodology[match.methodology_id].append(match)

        # Generate batches for each methodology
        for methodology_id, matches in by_methodology.items():
            methodology = methodologies.get(methodology_id)
            if not methodology or not methodology.batch_compatible:
                # Generate individual commands
                for match in matches:
                    batches.extend(self._generate_individual_commands(match, methodology))
            else:
                # Try to batch similar matches
                batches.extend(self._generate_batched_commands(matches, methodology))

        return batches

    def _generate_individual_commands(
        self,
        match: TriggerMatch,
        methodology: Methodology
    ) -> List[BatchCommand]:
        """Generate individual commands for a single trigger match."""
        commands = []

        for step in methodology.steps:
            command_str = step.resolve_command(match.matched_assets)

            batch_cmd = BatchCommand(
                id=str(uuid.uuid4()),
                methodology_id=methodology.id,
                command=command_str,
                trigger_matches=[match],
                target_count=len(match.matched_assets),
                metadata={
                    "step_id": step.id,
                    "step_name": step.name,
                    "batched": False
                }
            )
            commands.append(batch_cmd)

            # Mark the trigger match as batched
            match.batched = False
            match.batch_id = batch_cmd.id

        return commands

    def _generate_batched_commands(
        self,
        matches: List[TriggerMatch],
        methodology: Methodology
    ) -> List[BatchCommand]:
        """Generate batched commands for multiple similar trigger matches."""
        if len(matches) <= 1:
            return self._generate_individual_commands(matches[0], methodology)

        commands = []
        batch_id = str(uuid.uuid4())

        # Group assets by type for batching
        all_assets = []
        for match in matches:
            all_assets.extend(match.matched_assets)

        # Remove duplicates by asset ID
        unique_assets = {asset.id: asset for asset in all_assets}.values()

        for step in methodology.steps:
            # Check if this step can be batched
            if self._can_batch_step(step, list(unique_assets)):
                # Generate batch command
                command_str = self._generate_batch_command(step, list(unique_assets))

                batch_cmd = BatchCommand(
                    id=batch_id,
                    methodology_id=methodology.id,
                    command=command_str,
                    trigger_matches=matches,
                    target_count=len(unique_assets),
                    metadata={
                        "step_id": step.id,
                        "step_name": step.name,
                        "batched": True,
                        "batch_size": len(matches)
                    }
                )
                commands.append(batch_cmd)

                # Mark all trigger matches as batched
                for match in matches:
                    match.batched = True
                    match.batch_id = batch_id
            else:
                # Generate individual commands
                for match in matches:
                    commands.extend(self._generate_individual_commands(match, methodology))

        return commands

    def _can_batch_step(self, step: MethodologyStep, assets: List) -> bool:
        """Determine if a step can be batched."""
        # Check if command template supports batching
        template = step.command_template.lower()

        # Look for batch-friendly patterns
        batch_patterns = [
            "parallel",
            "-f {targets_file}",
            "--target-file",
            "-iL",
            "xargs",
            ":::"
        ]

        return any(pattern in template for pattern in batch_patterns)

    def _generate_batch_command(self, step: MethodologyStep, assets: List) -> str:
        """Generate a batch command for multiple assets."""
        command = step.command_template

        # Extract target values
        targets = []
        for asset in assets:
            # Try common target fields
            target = (
                asset.properties.get("ip") or
                asset.properties.get("host") or
                asset.properties.get("url") or
                asset.name
            )
            targets.append(str(target))

        # Replace batch placeholders
        if "{targets_file}" in command:
            # Would write to file in real implementation
            targets_str = "\\n".join(targets)
            command = command.replace("{targets_file}", f"<(echo -e '{targets_str}')")
        elif "{targets}" in command:
            command = command.replace("{targets}", " ".join(targets))
        elif ":::" in command:
            # GNU parallel style
            command = f"{command} ::: {' '.join(targets)}"

        # Replace count placeholder
        command = command.replace("{target_count}", str(len(targets)))

        return command
