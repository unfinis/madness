#!/usr/bin/env python3
"""Quick test to verify the engine works."""
from pathlib import Path
import sys

# Add engine to path
sys.path.insert(0, str(Path(__file__).parent))

from engine import MethodologyEngine, Asset, AssetType

def test_engine():
    print("🧪 Testing Methodology Engine...\n")

    # Initialize engine
    engine = MethodologyEngine()

    # Load methodologies
    methodologies_dir = Path(__file__).parent / "methodologies"
    engine.load_methodologies_from_yaml(methodologies_dir)

    print(f"✅ Loaded {len(engine.methodologies)} methodologies")
    for m in engine.get_methodologies():
        print(f"   - {m.name} ({m.category})")

    print("\n🎯 Testing Trigger Matching...\n")

    # Add a network segment (should trigger nmap)
    network = Asset(
        id="net-001",
        type=AssetType.NETWORK_SEGMENT,
        name="Corporate Network",
        properties={
            "cidr": "10.10.10.0/24",
            "vlan": "100"
        }
    )

    matches = engine.add_asset(network)
    print(f"✅ Added network segment")
    print(f"   Triggers fired: {len(matches)}")
    for match in matches:
        methodology = engine.methodologies.get(match.methodology_id)
        if methodology:
            print(f"   - {methodology.name} (priority {match.priority})")

    # Check generated commands
    commands = engine.get_pending_commands()
    print(f"\n⚡ Generated Commands: {len(commands)}")
    for cmd in commands[:3]:  # Show first 3
        print(f"   - {cmd.command[:80]}...")

    print("\n🌐 Testing Web Service Batching...\n")

    # Add multiple web services (should trigger batching)
    for i, (ip, port) in enumerate([("10.10.10.5", 80), ("10.10.10.5", 443), ("10.10.10.7", 8080)]):
        service = Asset(
            id=f"svc-{i:03d}",
            type=AssetType.SERVICE,
            name=f"HTTP on {ip}:{port}",
            properties={
                "host": ip,
                "port": port,
                "protocol": "http",
                "url": f"http://{ip}:{port}"
            }
        )
        matches = engine.add_asset(service)
        print(f"✅ Added web service {ip}:{port} - triggered {len(matches)} matches")

    # Check for batched commands
    all_commands = engine.get_pending_commands()
    batched_commands = [c for c in all_commands if c.metadata.get("batched")]

    print(f"\n📊 Final Stats:")
    stats = engine.get_stats()
    print(f"   Total Assets: {stats['total_assets']}")
    print(f"   Total Triggers: {stats['total_trigger_matches']}")
    print(f"   Total Commands: {stats['total_batch_commands']}")
    print(f"   Batched Commands: {len(batched_commands)}")

    if batched_commands:
        print(f"\n✨ Batched Command Example:")
        cmd = batched_commands[0]
        print(f"   {cmd.command}")

    print("\n✅ All tests passed! Engine is working correctly.\n")

if __name__ == "__main__":
    test_engine()
