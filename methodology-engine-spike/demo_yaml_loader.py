#!/usr/bin/env python3
"""Demonstration of YAML-based atomic step loading."""

from engine.atomic_engine import AtomicMethodologyEngine, create_asset
from engine.yaml_step_loader import load_atomic_steps
from engine.models import AssetType


def demo_yaml_loaded_steps():
    """Demonstrate loading atomic steps from YAML and using them."""
    print("=" * 80)
    print("YAML-BASED ATOMIC STEP LOADER DEMONSTRATION")
    print("=" * 80)
    print()

    # Initialize engine
    print("1. Initializing Atomic Methodology Engine...")
    engine = AtomicMethodologyEngine()
    print()

    # Load atomic steps from YAML files
    print("2. Loading atomic steps from YAML files...")
    steps, summary = load_atomic_steps()

    print(f"   Loaded {summary['files_loaded']} YAML files")
    print(f"   Found {len(steps)} atomic step definitions")

    if summary['errors_count'] > 0:
        print(f"   ⚠ {summary['errors_count']} errors encountered:")
        for error in summary['errors']:
            print(f"      - {error}")
    print()

    # Register loaded steps with engine
    print("3. Registering loaded steps with engine...")
    phase_counts = {}
    for step in steps:
        engine.register_step(step)
        phase = step.phase.value
        phase_counts[phase] = phase_counts.get(phase, 0) + 1

    print(f"   ✓ Registered {len(steps)} atomic steps")
    print()
    print("   Steps by Phase:")
    for phase, count in sorted(phase_counts.items()):
        print(f"      {phase}: {count} steps")
    print()

    # Show sample steps from each phase
    print("4. Sample Steps from Each Phase:")
    print()

    for phase in ['discovery', 'port_scanning', 'service_identification']:
        phase_steps = [s for s in steps if s.phase.value == phase]
        if phase_steps:
            sample = phase_steps[0]
            print(f"   [{phase.upper()}] {sample.name}")
            print(f"      ID: {sample.id}")
            print(f"      Priority: {sample.priority}")
            print(f"      Batch Compatible: {sample.batch_compatible}")
            print(f"      Trigger Conditions: {len(sample.trigger_conditions)}")
            print(f"      Commands: {len(sample.commands)}")
            if sample.commands:
                cmd = sample.commands[0]
                print(f"      Example Command: {cmd.tool} - {cmd.command[:60]}...")
            print()

    # Scenario: User adds a network segment
    print("5. Test Scenario: User adds network segment 192.168.1.0/24")
    print()

    subnet = create_asset(
        asset_type=AssetType.NETWORK_SEGMENT,
        name="Lab Network",
        properties={
            "cidr": "192.168.1.0/24",
            "description": "Internal lab network for testing"
        }
    )

    execution_ids = engine.add_asset(subnet)
    print(f"   ✓ Network segment added")
    print(f"   → Triggered {len(execution_ids)} step execution(s)")
    print()

    # Show what got triggered
    print("6. Triggered Steps (queued for execution):")
    pending = engine.get_pending_executions()
    for i, execution in enumerate(pending[:5], 1):
        step = engine.step_registry.get_step(execution.step_id)
        print(f"   {i}. [Priority {execution.priority}] {step.name}")
        print(f"      Phase: {step.phase.value}")
        print(f"      Step ID: {step.id}")
        if step.commands:
            cmd = step.commands[0]
            print(f"      Tool: {cmd.tool}")
            # Resolve placeholders
            resolved_cmd = cmd.resolve_placeholders(subnet)
            print(f"      Command: {resolved_cmd[:70]}...")
        print()

    # Simulate discovery completion
    print("7. Simulating discovery results...")
    print("   Found 2 hosts: 192.168.1.10, 192.168.1.20")
    print()

    hosts = []
    for ip_suffix in [10, 20]:
        host = create_asset(
            asset_type=AssetType.HOST,
            name=f"host-{ip_suffix}",
            properties={
                "ip": f"192.168.1.{ip_suffix}",
                "state": "up",
                "hostname": f"workstation{ip_suffix}.lab.local"
            }
        )
        hosts.append(host)
        execution_ids = engine.add_asset(host)
        print(f"   ✓ Added {host.properties['ip']} → Queued {len(execution_ids)} step(s)")

    print()

    # Show updated queue
    print("8. Updated Attack Queue:")
    pending = engine.get_pending_executions()
    print(f"   Total pending executions: {len(pending)}")
    print()
    print("   Next 5 steps to execute:")
    for i, execution in enumerate(pending[:5], 1):
        step = engine.step_registry.get_step(execution.step_id)
        asset = engine.get_asset(execution.asset_id)
        print(f"   {i}. [P:{execution.priority}] {step.name}")
        print(f"      Phase: {step.phase.value}")
        print(f"      Target: {asset.name} ({asset.properties.get('ip', asset.properties.get('cidr', 'N/A'))})")
    print()

    # Simulate port scan results
    print("9. Simulating port scan finding SSH service...")
    ssh_service = create_asset(
        asset_type=AssetType.SERVICE,
        name="SSH Service",
        properties={
            "host": "192.168.1.10",
            "port": 22,
            "protocol": "tcp",
            "state": "open"
        }
    )
    execution_ids = engine.add_asset(ssh_service)
    print(f"   ✓ Service added → Triggered {len(execution_ids)} identification step(s)")
    print()

    # Show final statistics
    print("10. Engine Statistics:")
    stats = engine.get_stats()
    print(f"    Total Assets: {stats['assets']['total']}")
    print(f"    - Network Segments: {stats['assets']['by_type'].get('network_segment', 0)}")
    print(f"    - Hosts: {stats['assets']['by_type'].get('host', 0)}")
    print(f"    - Services: {stats['assets']['by_type'].get('service', 0)}")
    print()
    print(f"    Total Step Executions: {stats['executions']['total']}")
    print(f"    - Pending: {stats['executions']['pending']}")
    print(f"    - Completed: {stats['executions']['completed']}")
    print()

    # Show which steps would execute next
    pending = engine.get_pending_executions()
    if pending:
        print("    Next Steps Ready to Execute:")
        for i, execution in enumerate(pending[:3], 1):
            step = engine.step_registry.get_step(execution.step_id)
            print(f"      {i}. [{step.phase.value}] {step.name} (Priority: {execution.priority})")

    print()
    print("=" * 80)
    print("DEMONSTRATION COMPLETE")
    print("=" * 80)
    print()
    print("Key Achievements:")
    print("  ✓ Successfully loaded atomic steps from YAML files")
    print("  ✓ Registered steps with atomic methodology engine")
    print(f"  ✓ {len(steps)} atomic steps available across {len(phase_counts)} phases")
    print("  ✓ State-driven triggers automatically queue appropriate steps")
    print("  ✓ Priority-based execution order maintained")
    print("  ✓ Natural pentest workflow: Discovery → Port Scan → Service ID")
    print()
    print("Next Steps:")
    print("  • Implement actual command execution")
    print("  • Build output parsers (nmap XML, masscan JSON, etc.)")
    print("  • Add service-specific enumeration steps (SSH, HTTP, SMB, etc.)")
    print("  • Create exploitation and post-exploitation steps")
    print()


if __name__ == "__main__":
    demo_yaml_loaded_steps()
