#!/usr/bin/env python3
"""Demonstration of the atomic step-based methodology engine."""

from engine.atomic_engine import AtomicMethodologyEngine, create_asset
from engine.atomic_steps import (
    AtomicStep, StepPhase, StepTriggerCondition,
    TriggerConditionType, CommandDefinition, OutputParser
)
from engine.models import AssetType


def create_demo_steps():
    """Create demo atomic steps for the demonstration."""

    # Step 1: Host Discovery (Ping Sweep)
    host_discovery = AtomicStep(
        id="host_discovery_ping_sweep",
        name="Host Discovery - ICMP Ping Sweep",
        description="Discover live hosts in a subnet using ICMP ping",
        phase=StepPhase.DISCOVERY,
        trigger_conditions=[
            StepTriggerCondition(
                condition_type=TriggerConditionType.ASSET_CREATED,
                asset_type=AssetType.NETWORK_SEGMENT
            )
        ],
        commands=[
            CommandDefinition(
                tool="nmap",
                command="nmap -sn -PE {cidr}",
                platforms=["linux", "macos"],
                timeout=300,
                notes="ICMP ping sweep to find live hosts"
            )
        ],
        priority=10,  # Highest priority - user-initiated
        batch_compatible=False,
        deduplication_signature_fields=["cidr"],
        next_step_ids=["port_scan_quick"]
    )

    # Step 2: Quick Port Scan
    port_scan_quick = AtomicStep(
        id="port_scan_quick",
        name="Quick Port Scan (Top 1000)",
        description="Scan top 1000 most common ports",
        phase=StepPhase.PORT_SCANNING,
        trigger_conditions=[
            StepTriggerCondition(
                condition_type=TriggerConditionType.ASSET_CREATED,
                asset_type=AssetType.HOST
            ),
            StepTriggerCondition(
                condition_type=TriggerConditionType.PROPERTY_MATCH,
                asset_type=AssetType.HOST,
                property_name="state",
                property_pattern="up"
            )
        ],
        commands=[
            CommandDefinition(
                tool="nmap",
                command="nmap -F -T4 {ip}",
                platforms=["linux", "macos"],
                timeout=300,
                notes="Fast scan of top 1000 ports"
            )
        ],
        priority=8,
        batch_compatible=True,
        max_batch_size=256,
        deduplication_signature_fields=["ip"]
    )

    # Step 3: Service Identification (Banner Grab)
    service_banner_grab = AtomicStep(
        id="service_banner_grab",
        name="Service Banner Grabbing",
        description="Grab service banner to identify service type",
        phase=StepPhase.SERVICE_IDENTIFICATION,
        trigger_conditions=[
            StepTriggerCondition(
                condition_type=TriggerConditionType.PROPERTY_NULL,
                asset_type=AssetType.SERVICE,
                property_name="service_type"
            )
        ],
        commands=[
            CommandDefinition(
                tool="nmap",
                command="nmap -sV -p {port} {host}",
                platforms=["linux", "macos"],
                timeout=60,
                notes="Service version detection"
            )
        ],
        priority=7,
        batch_compatible=True,
        deduplication_signature_fields=["host", "port"]
    )

    # Step 4: SSH Enumeration
    ssh_enumeration = AtomicStep(
        id="ssh_auth_methods_enum",
        name="SSH Authentication Methods",
        description="Enumerate SSH authentication methods",
        phase=StepPhase.SERVICE_ENUMERATION,
        trigger_conditions=[
            StepTriggerCondition(
                condition_type=TriggerConditionType.PROPERTY_MATCH,
                asset_type=AssetType.SERVICE,
                property_name="service_type",
                property_pattern="ssh"
            ),
            StepTriggerCondition(
                condition_type=TriggerConditionType.PROPERTY_NULL,
                asset_type=AssetType.SERVICE,
                property_name="auth_methods"
            )
        ],
        commands=[
            CommandDefinition(
                tool="nmap",
                command="nmap -p {port} --script ssh-auth-methods {host}",
                platforms=["linux", "macos"],
                timeout=30,
                notes="Enumerate SSH authentication methods"
            )
        ],
        priority=6,
        batch_compatible=True,
        deduplication_signature_fields=["host", "port"]
    )

    # Step 5: SSH User Enumeration
    ssh_user_enum = AtomicStep(
        id="ssh_user_enumeration",
        name="SSH User Enumeration",
        description="Enumerate valid SSH usernames via timing attack",
        phase=StepPhase.SERVICE_ENUMERATION,
        trigger_conditions=[
            StepTriggerCondition(
                condition_type=TriggerConditionType.PROPERTY_MATCH,
                asset_type=AssetType.SERVICE,
                property_name="service_type",
                property_pattern="ssh"
            ),
            StepTriggerCondition(
                condition_type=TriggerConditionType.PROPERTY_MATCH,
                asset_type=AssetType.SERVICE,
                property_name="allows_password_auth",
                property_pattern=True
            )
        ],
        commands=[
            CommandDefinition(
                tool="nmap",
                command="nmap -p {port} --script ssh-enum-users --script-args userdb=/usr/share/wordlists/usernames.txt {host}",
                platforms=["linux", "macos"],
                timeout=300,
                notes="Enumerate users via timing attack"
            )
        ],
        priority=6,
        batch_compatible=False,
        deduplication_signature_fields=["host", "port"],
        next_step_ids=["ssh_password_bruteforce"]
    )

    # Step 6: SSH Password Brute Force
    ssh_bruteforce = AtomicStep(
        id="ssh_password_bruteforce",
        name="SSH Password Brute Force",
        description="Brute force SSH passwords for discovered users",
        phase=StepPhase.EXPLOITATION,
        trigger_conditions=[
            StepTriggerCondition(
                condition_type=TriggerConditionType.PROPERTY_NOT_NULL,
                asset_type=AssetType.CREDENTIAL,
                property_name="username"
            ),
            StepTriggerCondition(
                condition_type=TriggerConditionType.PROPERTY_NULL,
                asset_type=AssetType.CREDENTIAL,
                property_name="password"
            )
        ],
        commands=[
            CommandDefinition(
                tool="hydra",
                command="hydra -l {username} -P /usr/share/wordlists/passwords.txt ssh://{host}:{port} -t 4",
                platforms=["linux", "macos"],
                timeout=3600,
                notes="SSH password brute force (use with caution)"
            )
        ],
        priority=5,
        batch_compatible=True,
        max_batch_size=10,
        deduplication_signature_fields=["host", "port", "username"]
    )

    return [
        host_discovery,
        port_scan_quick,
        service_banner_grab,
        ssh_enumeration,
        ssh_user_enum,
        ssh_bruteforce
    ]


def demo_basic_workflow():
    """Demonstrate basic workflow with the atomic engine."""
    print("=" * 80)
    print("ATOMIC METHODOLOGY ENGINE DEMONSTRATION")
    print("=" * 80)
    print()

    # Initialize engine
    print("1. Initializing Atomic Methodology Engine...")
    engine = AtomicMethodologyEngine()
    print()

    # Register demo steps
    print("2. Registering atomic steps...")
    steps = create_demo_steps()
    for step in steps:
        engine.register_step(step)
        print(f"   ✓ Registered: {step.name} (Phase: {step.phase.value}, Priority: {step.priority})")
    print()

    # Scenario: User adds a network segment
    print("3. User Action: Adding network segment 10.0.0.0/24")
    print()

    subnet = create_asset(
        asset_type=AssetType.NETWORK_SEGMENT,
        name="Internal Network",
        properties={
            "cidr": "10.0.0.0/24",
            "vlan": 100,
            "description": "Internal corporate network"
        }
    )

    execution_ids = engine.add_asset(subnet)
    print(f"   → Triggered {len(execution_ids)} step(s)")
    print()

    # Show queued steps
    print("4. Attack Queue Status:")
    pending = engine.get_pending_executions()
    for i, execution in enumerate(pending[:5], 1):
        step = engine.step_registry.get_step(execution.step_id)
        print(f"   {i}. [{execution.priority}] {step.name}")
        print(f"      Asset: {execution.asset_id}")
        print(f"      Signature: {execution.signature}")
    print()

    # Simulate host discovery results
    print("5. Simulating host discovery completion...")
    print("   Found 3 hosts: 10.0.0.50, 10.0.0.51, 10.0.0.52")
    print()

    # Create discovered hosts
    hosts = []
    for i in [50, 51, 52]:
        host = create_asset(
            asset_type=AssetType.HOST,
            name=f"host-{i}",
            properties={
                "ip": f"10.0.0.{i}",
                "state": "up",
                "hostname": f"server{i}.internal.local"
            }
        )
        hosts.append(host)
        execution_ids = engine.add_asset(host)
        print(f"   ✓ Added host {host.properties['ip']} → Queued {len(execution_ids)} step(s)")

    print()

    # Show updated queue
    print("6. Updated Attack Queue Status:")
    pending = engine.get_pending_executions()
    for i, execution in enumerate(pending[:10], 1):
        step = engine.step_registry.get_step(execution.step_id)
        asset = engine.get_asset(execution.asset_id)
        print(f"   {i}. [Priority {execution.priority}] {step.name}")
        print(f"      Phase: {step.phase.value}")
        print(f"      Asset: {asset.name} ({asset.properties.get('ip', 'N/A')})")
    print()

    # Simulate finding open port 22 (SSH)
    print("7. Simulating port scan completion...")
    print("   Found open port 22 on 10.0.0.50")
    print()

    ssh_service = create_asset(
        asset_type=AssetType.SERVICE,
        name="SSH Service",
        properties={
            "host": "10.0.0.50",
            "port": 22,
            "protocol": "tcp",
            "state": "open"
        }
    )

    execution_ids = engine.add_asset(ssh_service)
    print(f"   → Queued {len(execution_ids)} step(s) for service identification")
    print()

    # Simulate service identification
    print("8. Simulating service identification...")
    engine.update_asset(
        ssh_service.id,
        {
            "service_type": "ssh",
            "version": "OpenSSH 7.4",
            "banner": "SSH-2.0-OpenSSH_7.4"
        }
    )
    print("   ✓ Identified as SSH service")
    print()

    # Simulate SSH enumeration
    print("9. Simulating SSH enumeration...")
    engine.update_asset(
        ssh_service.id,
        {
            "auth_methods": ["publickey", "password"],
            "allows_password_auth": True
        }
    )
    print("   ✓ Enumerated auth methods: password authentication enabled")
    print()

    # Show final queue state
    print("10. Final Attack Queue State:")
    stats = engine.get_stats()
    print(f"    Total Assets: {stats['assets']['total']}")
    print(f"    Total Executions: {stats['executions']['total']}")
    print(f"    Pending: {stats['executions']['pending']}")
    print(f"    Completed: {stats['executions']['completed']}")
    print()

    pending = engine.get_pending_executions()
    if pending:
        print("    Next Steps to Execute:")
        for i, execution in enumerate(pending[:5], 1):
            step = engine.step_registry.get_step(execution.step_id)
            print(f"      {i}. [Priority {execution.priority}] {step.name} ({step.phase.value})")

    print()
    print("=" * 80)
    print("DEMONSTRATION COMPLETE")
    print("=" * 80)
    print()
    print("Key Observations:")
    print("  • Steps are automatically queued based on asset state changes")
    print("  • Priority determines execution order (lower number = higher priority)")
    print("  • Discovery (10) → Port Scan (8) → Service ID (7) → Enumeration (6)")
    print("  • Each asset change triggers appropriate next steps")
    print("  • Deduplication prevents duplicate executions")
    print("  • Steps can be batched for efficiency (e.g., scan multiple hosts)")
    print()


if __name__ == "__main__":
    demo_basic_workflow()
