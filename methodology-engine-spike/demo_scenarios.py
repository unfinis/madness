"""Rich demo scenarios showcasing asset relationships and methodology triggers."""
import uuid
from datetime import datetime
from engine import (
    Asset, AssetType, AssetRelationship, RelationshipType,
    MethodologyEngine
)


def create_multi_nic_pivot_scenario(engine: MethodologyEngine):
    """Scenario: Compromised dual-homed host enables network pivoting.

    Topology:
        External (10.5.5.0/24)
            ↓
        DMZ (10.1.1.0/24)
            ├─ WEB01 (dual-homed: 10.1.1.50 + 192.168.100.10)
            └─ WEB02 (10.1.1.51)
                ↓
        Internal (192.168.100.0/24)
            ├─ DB01 (192.168.100.20)
            └─ DC01 (192.168.100.10 - Domain Controller)

    Attack Scenario:
    1. Compromise WEB01 in DMZ
    2. Discover second NIC → TRIGGERS pivot methodology
    3. Pivot to internal network
    4. Compromise DB01 and DC01
    """
    print("\n🌐 Creating Multi-NIC Pivoting Scenario...")

    # Networks
    dmz_network = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.NETWORK_SEGMENT,
        name="DMZ Network",
        properties={
            "cidr": "10.1.1.0/24",
            "vlan_id": 10,
            "gateway": "10.1.1.1",
            "accessible_from": ["10.5.5.0/24"],
            "segmentation_type": "dmz",
            "monitored": True,
            "ids_enabled": True
        }
    )

    internal_network = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.NETWORK_SEGMENT,
        name="Internal Network",
        properties={
            "cidr": "192.168.100.0/24",
            "vlan_id": 100,
            "gateway": "192.168.100.1",
            "segmentation_type": "corporate",
            "monitored": True,
            "high_value": True
        }
    )

    # Dual-homed host (PIVOT OPPORTUNITY!)
    web01 = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.HOST,
        name="WEB01",
        properties={
            "hostname": "WEB01.dmz.corp",
            "os": "Ubuntu 20.04",
            "access_level": "full",  # Compromised!
            "network_interfaces": [
                {
                    "name": "eth0",
                    "ip": "10.1.1.50",
                    "mac": "00:0c:29:3a:2b:1c",
                    "network": "10.1.1.0/24",
                    "status": "up"
                },
                {
                    "name": "eth1",
                    "ip": "192.168.100.10",
                    "mac": "00:0c:29:3a:2b:1d",
                    "network": "192.168.100.0/24",
                    "status": "up"
                }
            ],
            "open_ports": [22, 80, 443],
            "compromised": True,
            "pivot_potential": "high"
        }
    )

    # Other hosts
    web02 = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.HOST,
        name="WEB02",
        properties={
            "hostname": "WEB02.dmz.corp",
            "os": "Ubuntu 20.04",
            "network_interfaces": [
                {"name": "eth0", "ip": "10.1.1.51", "network": "10.1.1.0/24"}
            ],
            "open_ports": [22, 80, 443]
        }
    )

    db01 = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.HOST,
        name="DB01",
        properties={
            "hostname": "DB01.corp.local",
            "os": "Windows Server 2019",
            "network_interfaces": [
                {"name": "Ethernet0", "ip": "192.168.100.20", "network": "192.168.100.0/24"}
            ],
            "open_ports": [1433, 3389],
            "high_value": True,
            "contains_sensitive_data": True
        }
    )

    dc01 = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.DOMAIN_CONTROLLER,
        name="DC01",
        properties={
            "hostname": "DC01.corp.local",
            "os": "Windows Server 2019",
            "domain": "corp.local",
            "network_interfaces": [
                {"name": "Ethernet0", "ip": "192.168.100.10", "network": "192.168.100.0/24"}
            ],
            "open_ports": [88, 389, 445, 3389],
            "high_value": True,
            "domain_admin_access": False
        }
    )

    # Add assets
    for asset in [dmz_network, internal_network, web01, web02, db01, dc01]:
        engine.add_asset(asset)

    # Create relationships
    relationships = [
        # Network membership
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=web01.id,
            target_asset_id=dmz_network.id,
            relationship_type=RelationshipType.MEMBER_OF,
            properties={"interface": "eth0"}
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=web02.id,
            target_asset_id=dmz_network.id,
            relationship_type=RelationshipType.MEMBER_OF
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=db01.id,
            target_asset_id=internal_network.id,
            relationship_type=RelationshipType.MEMBER_OF
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=dc01.id,
            target_asset_id=internal_network.id,
            relationship_type=RelationshipType.MEMBER_OF
        ),

        # PIVOT RELATIONSHIP - KEY CAPABILITY!
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=web01.id,
            target_asset_id=internal_network.id,
            relationship_type=RelationshipType.CAN_PIVOT_TO,
            properties={
                "interface": "eth1",
                "requires_routing": False,
                "direct_access": True
            }
        ),
    ]

    for rel in relationships:
        engine.add_relationship(rel)

    print(f"   ✅ Created {len([dmz_network, internal_network, web01, web02, db01, dc01])} assets")
    print(f"   ✅ Created {len(relationships)} relationships")
    print(f"   🎯 WEB01 is dual-homed - can pivot to internal network!")


def create_firewall_traversal_scenario(engine: MethodologyEngine):
    """Scenario: Firewall-allowlisted host enables access to restricted networks.

    Topology:
        Internet
            ↓
        [FIREWALL] - Blocks all except allowlist
            ↓
        Jump Box (ALLOWLISTED!)
            ↓
        Restricted Internal Network
            ├─ PROD-WEB01
            ├─ PROD-DB01
            └─ ADMIN01

    Attack Scenario:
    1. Compromise Jump Box
    2. Discover firewall allowlist → TRIGGERS traversal methodology
    3. Use Jump Box to access restricted internal hosts
    """
    print("\n🔥 Creating Firewall Traversal Scenario...")

    # Networks
    restricted_network = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.NETWORK_SEGMENT,
        name="Production Network (Restricted)",
        properties={
            "cidr": "172.16.50.0/24",
            "vlan_id": 50,
            "gateway": "172.16.50.1",
            "segmentation_type": "production",
            "firewall_protected": True,
            "access_restricted": True,
            "high_value": True
        }
    )

    dmz_network = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.NETWORK_SEGMENT,
        name="Management DMZ",
        properties={
            "cidr": "10.10.10.0/24",
            "vlan_id": 20,
            "gateway": "10.10.10.1",
            "segmentation_type": "management"
        }
    )

    # Firewall
    firewall = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.FIREWALL,
        name="Corporate Firewall",
        properties={
            "vendor": "Palo Alto",
            "model": "PA-3020",
            "default_policy": "deny",
            "allowlist_enabled": True
        }
    )

    # Jump Box (ALLOWLISTED - this is the golden ticket!)
    jump_box = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.HOST,
        name="JUMP01",
        properties={
            "hostname": "JUMP01.mgmt.corp",
            "os": "Ubuntu 22.04",
            "access_level": "full",  # Compromised!
            "network_interfaces": [
                {"name": "eth0", "ip": "10.10.10.50", "network": "10.10.10.0/24"}
            ],
            "firewall_allowlisted_for": [
                "172.16.50.0/24",  # PRODUCTION NETWORK!
                "192.168.200.0/24"  # ADMIN NETWORK!
            ],
            "open_ports": [22],
            "compromised": True,
            "strategic_value": "critical"
        }
    )

    # Restricted hosts
    prod_web = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.HOST,
        name="PROD-WEB01",
        properties={
            "hostname": "PROD-WEB01.corp.local",
            "os": "RHEL 8",
            "network_interfaces": [
                {"name": "eth0", "ip": "172.16.50.10", "network": "172.16.50.0/24"}
            ],
            "open_ports": [80, 443],
            "environment": "production",
            "high_value": True
        }
    )

    prod_db = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.DATABASE,
        name="PROD-DB01",
        properties={
            "hostname": "PROD-DB01.corp.local",
            "os": "Windows Server 2019",
            "database_type": "SQL Server",
            "network_interfaces": [
                {"name": "Ethernet0", "ip": "172.16.50.20", "network": "172.16.50.0/24"}
            ],
            "open_ports": [1433],
            "contains_customer_data": True,
            "high_value": True
        }
    )

    # Add assets
    for asset in [restricted_network, dmz_network, firewall, jump_box, prod_web, prod_db]:
        engine.add_asset(asset)

    # Create relationships
    relationships = [
        # Network membership
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=jump_box.id,
            target_asset_id=dmz_network.id,
            relationship_type=RelationshipType.MEMBER_OF
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=prod_web.id,
            target_asset_id=restricted_network.id,
            relationship_type=RelationshipType.MEMBER_OF
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=prod_db.id,
            target_asset_id=restricted_network.id,
            relationship_type=RelationshipType.MEMBER_OF
        ),

        # Firewall relationships
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=restricted_network.id,
            target_asset_id=firewall.id,
            relationship_type=RelationshipType.BLOCKED_BY,
            properties={"default_policy": "deny"}
        ),

        # ALLOWLIST RELATIONSHIP - KEY CAPABILITY!
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=jump_box.id,
            target_asset_id=firewall.id,
            relationship_type=RelationshipType.ALLOWED_BY,
            properties={
                "rule_id": "FW-RULE-1234",
                "allowed_destinations": ["172.16.50.0/24"],
                "ports": ["any"]
            }
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=firewall.id,
            target_asset_id=restricted_network.id,
            relationship_type=RelationshipType.ALLOWS_ACCESS_TO,
            properties={"source": "10.10.10.50"}  # Jump box IP
        ),
    ]

    for rel in relationships:
        engine.add_relationship(rel)

    print(f"   ✅ Created {len([restricted_network, dmz_network, firewall, jump_box, prod_web, prod_db])} assets")
    print(f"   ✅ Created {len(relationships)} relationships")
    print(f"   🎯 JUMP01 is allowlisted through firewall for production network!")


def create_privesc_scenario(engine: MethodologyEngine):
    """Scenario: Misconfigured application enables privilege escalation.

    Situation:
        Low-privilege shell on APP01
        ↓
        Apache Tomcat running with weak permissions
        ↓
        Writable config files + library loading
        ↓
        ROOT ACCESS!

    Attack Scenario:
    1. Compromise APP01 with low-privilege user
    2. Discover Tomcat with weak perms → TRIGGERS privesc methodology
    3. Exploit writable configs or library loading
    4. Escalate to root
    """
    print("\n⬆️  Creating Privilege Escalation Scenario...")

    # Network
    app_network = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.NETWORK_SEGMENT,
        name="Application Tier",
        properties={
            "cidr": "10.20.30.0/24",
            "vlan_id": 30,
            "gateway": "10.20.30.1",
            "segmentation_type": "application"
        }
    )

    # Host with low-privilege access
    app01 = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.HOST,
        name="APP01",
        properties={
            "hostname": "APP01.app.corp",
            "os": "Ubuntu 18.04",
            "access_level": "limited",  # Low-priv shell!
            "network_interfaces": [
                {"name": "eth0", "ip": "10.20.30.15", "network": "10.20.30.0/24"}
            ],
            "users": ["www-data", "tomcat", "backup", "root"],
            "current_user": "www-data",
            "current_uid": 33,
            "open_ports": [22, 8080, 8443]
        }
    )

    # Misconfigured Tomcat (PRIVESC VECTOR!)
    tomcat_app = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.APPLICATION,
        name="Apache Tomcat",
        properties={
            "name": "Apache Tomcat",
            "version": "9.0.45",
            "install_path": "/opt/tomcat",
            "running_as_user": "tomcat",
            "running_as_uid": 1001,

            # PRIVESC INDICATORS!
            "writable_by": ["tomcat", "www-data"],
            "writable_configs": True,
            "config_path": "/opt/tomcat/conf",
            "can_load_libraries": True,
            "lib_path_writable": True,
            "has_suid": False,
            "sudo_permissions": [],

            # Vulnerability classification
            "privesc_potential": "high",
            "exploitable": True,
            "misconfigurations": [
                "weak_permissions",
                "writable_configs",
                "library_loading_possible"
            ],

            # CVEs
            "vulnerabilities": ["CVE-2021-33037"],
            "patch_level": "outdated"
        }
    )

    # Also add nginx with SUID binary (another privesc path)
    nginx_app = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.APPLICATION,
        name="Nginx",
        properties={
            "name": "nginx",
            "version": "1.18.0",
            "install_path": "/usr/sbin/nginx",
            "running_as_user": "www-data",

            # PRIVESC via SUID!
            "has_suid": True,
            "suid_binaries": ["/usr/local/bin/nginx-helper"],
            "privesc_potential": "medium",
            "exploitable": True,
            "misconfigurations": ["suid_binary"]
        }
    )

    # Add assets
    for asset in [app_network, app01, tomcat_app, nginx_app]:
        engine.add_asset(asset)

    # Create relationships
    relationships = [
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=app01.id,
            target_asset_id=app_network.id,
            relationship_type=RelationshipType.MEMBER_OF
        ),

        # INSTALLED_ON relationships
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=tomcat_app.id,
            target_asset_id=app01.id,
            relationship_type=RelationshipType.INSTALLED_ON
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=nginx_app.id,
            target_asset_id=app01.id,
            relationship_type=RelationshipType.INSTALLED_ON
        ),

        # ENABLES relationship (privesc!)
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=tomcat_app.id,
            target_asset_id=app01.id,
            relationship_type=RelationshipType.ENABLES,
            properties={
                "enables": "privilege_escalation",
                "from_user": "www-data",
                "to_user": "root",
                "method": "writable_configs_and_library_loading"
            }
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=nginx_app.id,
            target_asset_id=app01.id,
            relationship_type=RelationshipType.ENABLES,
            properties={
                "enables": "privilege_escalation",
                "method": "suid_binary_exploitation"
            }
        ),
    ]

    for rel in relationships:
        engine.add_relationship(rel)

    print(f"   ✅ Created {len([app_network, app01, tomcat_app, nginx_app])} assets")
    print(f"   ✅ Created {len(relationships)} relationships")
    print(f"   🎯 Tomcat has writable configs - HIGH privesc potential!")


def create_full_attack_chain_scenario(engine: MethodologyEngine):
    """Scenario: Complete attack chain from external to domain admin.

    Attack Path:
        External Access
            ↓
        Exploit Web App (Initial Access)
            ↓
        Pivot via Dual-Homed Host
            ↓
        Credential Discovery
            ↓
        Lateral Movement to File Server
            ↓
        Domain Admin Hash Extraction
            ↓
        Domain Controller Compromise

    This demonstrates the full power of relationship-driven methodologies!
    """
    print("\n⚔️  Creating Full Attack Chain Scenario...")

    # Networks
    external = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.NETWORK_SEGMENT,
        name="External Network",
        properties={"cidr": "0.0.0.0/0", "trust_level": "untrusted"}
    )

    dmz = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.NETWORK_SEGMENT,
        name="DMZ",
        properties={"cidr": "10.0.1.0/24", "segmentation_type": "dmz"}
    )

    internal = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.NETWORK_SEGMENT,
        name="Internal Corporate Network",
        properties={
            "cidr": "192.168.10.0/24",
            "segmentation_type": "corporate",
            "contains_domain_controllers": True
        }
    )

    # Vulnerable web server (entry point)
    web_vuln = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.WEB_APPLICATION,
        name="Corporate Portal",
        properties={
            "url": "https://portal.corp.com",
            "framework": "WordPress",
            "version": "5.8.0",
            "plugins": ["outdated_file_manager_3.2"],
            "vulnerabilities": ["CVE-2021-24123"]
        }
    )

    web_server = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.HOST,
        name="WEBEXT01",
        properties={
            "hostname": "WEBEXT01.dmz.corp",
            "os": "Ubuntu 20.04",
            "access_level": "full",  # Compromised via web vuln!
            "network_interfaces": [
                {"name": "eth0", "ip": "10.0.1.10", "network": "10.0.1.0/24"},
                {"name": "eth1", "ip": "192.168.10.50", "network": "192.168.10.0/24"}
            ],
            "compromised": True
        }
    )

    # Discovered credentials
    creds = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.CREDENTIAL,
        name="Domain Service Account",
        properties={
            "username": "svc_backup",
            "domain": "CORP",
            "credential_type": "password",
            "password": "Summer2023!",
            "discovered_from": "config_file",
            "privileges": ["Domain Users", "Backup Operators"]
        }
    )

    # File server (lateral movement target)
    file_server = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.HOST,
        name="FILES01",
        properties={
            "hostname": "FILES01.corp.local",
            "os": "Windows Server 2019",
            "network_interfaces": [
                {"name": "Ethernet0", "ip": "192.168.10.30", "network": "192.168.10.0/24"}
            ],
            "open_ports": [445, 3389],
            "admin_shares_accessible": True
        }
    )

    # Domain controller (ultimate target)
    dc = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.DOMAIN_CONTROLLER,
        name="DC01",
        properties={
            "hostname": "DC01.corp.local",
            "os": "Windows Server 2019",
            "domain": "corp.local",
            "network_interfaces": [
                {"name": "Ethernet0", "ip": "192.168.10.10", "network": "192.168.10.0/24"}
            ],
            "open_ports": [88, 389, 445, 3389, 636],
            "high_value": True
        }
    )

    # Add assets
    for asset in [external, dmz, internal, web_vuln, web_server, creds, file_server, dc]:
        engine.add_asset(asset)

    # Create attack chain relationships
    relationships = [
        # Initial access
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=web_vuln.id,
            target_asset_id=web_server.id,
            relationship_type=RelationshipType.RUNS_ON
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=web_server.id,
            target_asset_id=dmz.id,
            relationship_type=RelationshipType.MEMBER_OF
        ),

        # Pivoting capability
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=web_server.id,
            target_asset_id=internal.id,
            relationship_type=RelationshipType.CAN_PIVOT_TO,
            properties={"interface": "eth1"}
        ),

        # Credential usage
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=creds.id,
            target_asset_id=file_server.id,
            relationship_type=RelationshipType.WORKS_ON
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=creds.id,
            target_asset_id=file_server.id,
            relationship_type=RelationshipType.GRANTS_ACCESS_TO,
            properties={"access_level": "admin"}
        ),

        # File server in domain
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=file_server.id,
            target_asset_id=internal.id,
            relationship_type=RelationshipType.MEMBER_OF
        ),
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=file_server.id,
            target_asset_id=dc.id,
            relationship_type=RelationshipType.DOMAIN_MEMBER,
            properties={"domain": "corp.local"}
        ),

        # DC relationships
        AssetRelationship(
            id=str(uuid.uuid4()),
            source_asset_id=dc.id,
            target_asset_id=internal.id,
            relationship_type=RelationshipType.MEMBER_OF
        ),
    ]

    for rel in relationships:
        engine.add_relationship(rel)

    print(f"   ✅ Created {len([external, dmz, internal, web_vuln, web_server, creds, file_server, dc])} assets")
    print(f"   ✅ Created {len(relationships)} relationships")
    print(f"   🎯 Complete attack path: Web → Pivot → Lateral → Domain Admin!")


# Scenario registry
SCENARIOS = {
    "multi_nic_pivot": {
        "name": "Multi-NIC Pivoting",
        "description": "Dual-homed host enables network pivoting to internal network",
        "function": create_multi_nic_pivot_scenario
    },
    "firewall_traversal": {
        "name": "Firewall Traversal",
        "description": "Compromised allowlisted host bypasses firewall to restricted networks",
        "function": create_firewall_traversal_scenario
    },
    "privilege_escalation": {
        "name": "Privilege Escalation",
        "description": "Misconfigured applications enable privilege escalation to root",
        "function": create_privesc_scenario
    },
    "full_attack_chain": {
        "name": "Full Attack Chain",
        "description": "Complete attack path from external access to domain admin",
        "function": create_full_attack_chain_scenario
    }
}


def load_scenario(engine: MethodologyEngine, scenario_name: str):
    """Load a specific demo scenario."""
    if scenario_name not in SCENARIOS:
        raise ValueError(f"Unknown scenario: {scenario_name}. Available: {', '.join(SCENARIOS.keys())}")

    scenario = SCENARIOS[scenario_name]
    print(f"\n{'='*70}")
    print(f"Loading Scenario: {scenario['name']}")
    print(f"Description: {scenario['description']}")
    print(f"{'='*70}")

    scenario["function"](engine)

    print(f"\n{'='*70}")
    print(f"✅ Scenario '{scenario['name']}' loaded successfully!")
    print(f"{'='*70}\n")


def load_all_scenarios(engine: MethodologyEngine):
    """Load all demo scenarios."""
    print("\n" + "="*70)
    print("🎭 LOADING ALL DEMO SCENARIOS")
    print("="*70)

    for scenario_name in SCENARIOS.keys():
        load_scenario(engine, scenario_name)

    # Print summary
    stats = engine.get_stats()
    relationship_stats = stats.get("relationship_stats", {})

    print("\n" + "="*70)
    print("📊 SUMMARY")
    print("="*70)
    print(f"Total Assets:        {stats['total_assets']}")
    print(f"Total Relationships: {relationship_stats.get('total_relationships', 0)}")
    print(f"Trigger Matches:     {stats['total_trigger_matches']}")
    print(f"Batch Commands:      {stats['total_batch_commands']}")
    print("\nAssets by Type:")
    for asset_type, count in stats['assets_by_type'].items():
        print(f"  • {asset_type}: {count}")

    # Show compromise candidates
    candidates = engine.get_compromise_candidates()
    if candidates:
        print(f"\n🎯 TOP COMPROMISE CANDIDATES:")
        for i, c in enumerate(candidates[:5], 1):
            print(f"  {i}. {c['asset'].name} (Score: {c['score']})")
            for reason in c['reasons'][:3]:
                print(f"     - {reason}")

    print("="*70 + "\n")
