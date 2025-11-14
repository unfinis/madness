"""YAML loader for atomic step definitions."""
import yaml
from pathlib import Path
from typing import Dict, List, Optional, Any
from .atomic_steps import (
    AtomicStep, StepPhase, StepTriggerCondition,
    TriggerConditionType, CommandDefinition, OutputParser
)
from .models import AssetType


class YAMLStepLoader:
    """Loads atomic steps from YAML files."""

    def __init__(self):
        self.loaded_files: List[str] = []
        self.errors: List[Dict[str, str]] = []

    def load_step_file(self, file_path: str) -> List[AtomicStep]:
        """Load atomic steps from a YAML file.

        Args:
            file_path: Path to YAML file containing step definitions

        Returns:
            List of AtomicStep objects loaded from file
        """
        steps = []

        try:
            with open(file_path, 'r') as f:
                data = yaml.safe_load(f)

            if not data or 'steps' not in data:
                self.errors.append({
                    'file': file_path,
                    'error': 'No steps found in YAML file'
                })
                return steps

            for step_data in data['steps']:
                try:
                    step = self._parse_step(step_data)
                    steps.append(step)
                except Exception as e:
                    self.errors.append({
                        'file': file_path,
                        'step_id': step_data.get('id', 'unknown'),
                        'error': str(e)
                    })

            self.loaded_files.append(file_path)

        except Exception as e:
            self.errors.append({
                'file': file_path,
                'error': f'Failed to load file: {str(e)}'
            })

        return steps

    def load_steps_from_directory(self, directory: str) -> List[AtomicStep]:
        """Load all atomic steps from YAML files in a directory.

        Args:
            directory: Path to directory containing YAML files

        Returns:
            List of all AtomicStep objects loaded
        """
        all_steps = []
        dir_path = Path(directory)

        if not dir_path.exists():
            self.errors.append({
                'directory': directory,
                'error': 'Directory does not exist'
            })
            return all_steps

        # Recursively find all .yaml and .yml files
        for yaml_file in dir_path.rglob('*.yaml'):
            steps = self.load_step_file(str(yaml_file))
            all_steps.extend(steps)

        for yaml_file in dir_path.rglob('*.yml'):
            steps = self.load_step_file(str(yaml_file))
            all_steps.extend(steps)

        return all_steps

    def _parse_step(self, data: Dict[str, Any]) -> AtomicStep:
        """Parse atomic step from YAML data.

        Args:
            data: Dictionary containing step data from YAML

        Returns:
            AtomicStep object
        """
        # Required fields
        step_id = data['id']
        name = data['name']
        description = data['description']
        phase = self._parse_phase(data['phase'])
        trigger_conditions = self._parse_trigger_conditions(data['trigger_conditions'])
        commands = self._parse_commands(data['commands'])

        # Optional fields with defaults
        priority = data.get('priority', 5)
        timeout_seconds = data.get('timeout_seconds', 300)
        deduplication_signature_fields = data.get('deduplication_signature_fields', [])
        batch_compatible = data.get('batch_compatible', False)
        max_batch_size = data.get('max_batch_size', 100)
        cooldown_seconds = data.get('cooldown_seconds')
        next_step_ids = data.get('next_step_ids', [])
        failure_step_ids = data.get('failure_step_ids', [])
        tags = data.get('tags', [])
        metadata = data.get('metadata', {})

        # Output parser (optional)
        output_parser = None
        if 'output_parser' in data:
            output_parser = self._parse_output_parser(data['output_parser'])

        return AtomicStep(
            id=step_id,
            name=name,
            description=description,
            phase=phase,
            trigger_conditions=trigger_conditions,
            commands=commands,
            priority=priority,
            timeout_seconds=timeout_seconds,
            output_parser=output_parser,
            next_step_ids=next_step_ids,
            failure_step_ids=failure_step_ids,
            deduplication_signature_fields=deduplication_signature_fields,
            cooldown_seconds=cooldown_seconds,
            batch_compatible=batch_compatible,
            max_batch_size=max_batch_size,
            tags=tags,
            metadata=metadata
        )

    def _parse_phase(self, phase_str: str) -> StepPhase:
        """Parse phase string to StepPhase enum."""
        phase_map = {
            'discovery': StepPhase.DISCOVERY,
            'port_scanning': StepPhase.PORT_SCANNING,
            'service_identification': StepPhase.SERVICE_IDENTIFICATION,
            'service_enumeration': StepPhase.SERVICE_ENUMERATION,
            'vulnerability_assessment': StepPhase.VULNERABILITY_ASSESSMENT,
            'exploitation': StepPhase.EXPLOITATION,
            'post_exploitation': StepPhase.POST_EXPLOITATION,
            'reporting': StepPhase.REPORTING,
        }

        if phase_str not in phase_map:
            raise ValueError(f"Unknown phase: {phase_str}")

        return phase_map[phase_str]

    def _parse_trigger_conditions(self, conditions: List[Dict]) -> List[StepTriggerCondition]:
        """Parse trigger conditions from YAML data."""
        parsed_conditions = []

        for cond in conditions:
            condition_type = self._parse_trigger_type(cond['type'])
            asset_type = self._parse_asset_type(cond['asset_type'])

            property_name = cond.get('property_name')
            property_value = cond.get('property_value')
            property_pattern = cond.get('property_pattern')

            parsed_conditions.append(StepTriggerCondition(
                condition_type=condition_type,
                asset_type=asset_type,
                property_name=property_name,
                property_value=property_value,
                property_pattern=property_pattern
            ))

        return parsed_conditions

    def _parse_trigger_type(self, type_str: str) -> TriggerConditionType:
        """Parse trigger type string to TriggerConditionType enum."""
        type_map = {
            'asset_created': TriggerConditionType.ASSET_CREATED,
            'property_set': TriggerConditionType.PROPERTY_SET,
            'property_updated': TriggerConditionType.PROPERTY_UPDATED,
            'property_match': TriggerConditionType.PROPERTY_MATCH,
            'property_null': TriggerConditionType.PROPERTY_NULL,
            'property_not_null': TriggerConditionType.PROPERTY_NOT_NULL,
        }

        if type_str not in type_map:
            raise ValueError(f"Unknown trigger type: {type_str}")

        return type_map[type_str]

    def _parse_asset_type(self, type_str: str) -> AssetType:
        """Parse asset type string to AssetType enum."""
        type_map = {
            'host': AssetType.HOST,
            'service': AssetType.SERVICE,
            'credential': AssetType.CREDENTIAL,
            'vulnerability': AssetType.VULNERABILITY,
            'finding': AssetType.FINDING,
            'network_segment': AssetType.NETWORK_SEGMENT,
            'domain': AssetType.DOMAIN,
        }

        if type_str not in type_map:
            raise ValueError(f"Unknown asset type: {type_str}")

        return type_map[type_str]

    def _parse_commands(self, commands: List[Dict]) -> List[CommandDefinition]:
        """Parse command definitions from YAML data."""
        parsed_commands = []

        for cmd in commands:
            tool = cmd['tool']
            command = cmd['command']
            platforms = cmd.get('platforms', ['linux', 'macos', 'windows'])
            timeout = cmd.get('timeout', 300)
            preferred = cmd.get('preferred', True)
            requires_elevation = cmd.get('requires_elevation', False)
            notes = cmd.get('notes', '')

            parsed_commands.append(CommandDefinition(
                tool=tool,
                command=command,
                platforms=platforms,
                timeout=timeout,
                preferred=preferred,
                requires_elevation=requires_elevation,
                notes=notes
            ))

        return parsed_commands

    def _parse_output_parser(self, parser_data: Dict) -> Optional[OutputParser]:
        """Parse output parser configuration from YAML data."""
        parser_type = parser_data.get('type', 'regex')
        patterns = parser_data.get('patterns', {})
        creates_assets = parser_data.get('creates_assets', [])
        updates_asset = parser_data.get('updates_asset', {})

        return OutputParser(
            parser_type=parser_type,
            patterns=patterns,
            creates_assets=creates_assets,
            updates_asset=updates_asset,
            custom_parser=None  # Custom parsers registered separately
        )

    def get_load_summary(self) -> Dict[str, Any]:
        """Get summary of loaded steps and any errors.

        Returns:
            Dictionary with files loaded, step count, and errors
        """
        return {
            'files_loaded': len(self.loaded_files),
            'files': self.loaded_files,
            'errors_count': len(self.errors),
            'errors': self.errors
        }


def load_atomic_steps(directory: str = None) -> tuple[List[AtomicStep], Dict[str, Any]]:
    """Convenience function to load atomic steps from a directory.

    Args:
        directory: Path to directory containing atomic step YAML files.
                  Defaults to atomic_steps/ in methodology-engine-spike/

    Returns:
        Tuple of (list of AtomicStep objects, load summary dict)
    """
    if directory is None:
        # Default to atomic_steps directory relative to this file
        current_file = Path(__file__).resolve()
        spike_root = current_file.parent.parent
        directory = str(spike_root / 'atomic_steps')

    loader = YAMLStepLoader()
    steps = loader.load_steps_from_directory(directory)
    summary = loader.get_load_summary()

    return steps, summary
