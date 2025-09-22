# 🎯 **Asset-Property-Driven Trigger System**

## **Vision: Smart, Efficient Attack Orchestration**

Transform the methodology trigger system from outcome-based to asset-property-based for more realistic, efficient, and intelligent penetration testing workflows.

---

## 🏗️ **Core Architecture Principles**

### **1. Asset Properties Drive Actions**
Instead of "methodology completes → trigger next methodology", use:
```
Asset Properties + Conditions → Trigger Methodology → Update Asset Properties
```

### **2. Trigger Deduplication & Completion Tracking**
- Track which property combinations have been attempted
- Prevent redundant methodology executions
- Mark trigger combinations as "completed" or "failed"

### **3. Batch Command Generation**
- Combine multiple similar triggers into single commands
- Optimize for efficiency (e.g., scan all web services at once)
- Generate complex commands that handle multiple conditions

---

## 📊 **Asset Property Examples**

### **Network Segment Asset**
```yaml
asset_type: network_segment
id: "corp_network_192_168_1_0"
properties:
  # Network Configuration
  subnet: "192.168.1.0/24"
  gateway: "192.168.1.1"
  dns_servers: ["192.168.1.1", "8.8.8.8"]
  domain_name: "corp.local"

  # Security Controls
  nac_enabled: true
  nac_type: "802.1x"
  firewall_present: true
  vlan_segmentation: true

  # Access Status
  access_level: "blocked"  # blocked|limited|partial|full
  authentication_required: true
  bypass_methods_attempted: ["mac_spoofing", "dhcp_exhaustion"]

  # Discovered Assets
  live_hosts: ["192.168.1.10", "192.168.1.20", "192.168.1.50"]
  web_services: [
    {host: "192.168.1.10", port: 80, service: "nginx", version: "1.18"},
    {host: "192.168.1.20", port: 443, service: "apache", ssl: true}
  ]
  smb_hosts: ["192.168.1.50"]
  domain_controllers: ["192.168.1.10"]

  # Available Resources
  credentials_available: [
    {username: "corp\\jdoe", password: "Password123", source: "llmnr_poisoning"},
    {username: "admin", hash: "aad3b435b51404ee...", source: "hash_dump"}
  ]
  certificates_found: ["corp-ca.crt"]
```

### **Host Asset**
```yaml
asset_type: host
id: "host_192_168_1_10"
properties:
  ip_address: "192.168.1.10"
  hostname: "DC01.corp.local"
  os_type: "windows"
  os_version: "Windows Server 2019"

  # Services
  open_ports: [22, 80, 135, 139, 445, 3389]
  services: [
    {port: 80, service: "http", banner: "nginx/1.18"},
    {port: 445, service: "smb", version: "SMBv3"}
  ]

  # Security Status
  smb_signing: false
  rpc_accessible: true
  rdp_enabled: true
  antivirus: "Windows Defender"

  # Access Status
  credentials_tested: [
    {cred: "admin:admin", result: "failed", timestamp: "2024-01-15T10:30:00Z"}
  ]
  shells_obtained: []
  privilege_level: "none"
```

---

## ⚡ **Trigger System Design**

### **Property-Based Trigger Conditions**
```yaml
methodology: nac_credential_testing
trigger_conditions:
  asset_type: network_segment
  all_conditions:
    - property: nac_enabled
      operator: equals
      value: true
    - property: credentials_available
      operator: exists
    - property: access_level
      operator: in
      values: ["blocked", "limited"]

deduplication_key: "{asset_id}:nac_cred_test:{credentials_hash}"
batch_capable: true
```

### **Batch Command Generation**
```yaml
# Individual triggers become batch operations
web_service_enumeration:
  trigger_condition: web_services.count > 0
  individual_command: "nikto -h {host}:{port}"
  batch_command: |
    # Generate targets file
    echo "{web_services_urls}" > /tmp/web_targets.txt
    # Run batch scan
    eyewitness --web -f /tmp/web_targets.txt --no-prompt -d /tmp/screenshots
    # Parse results
    for url in $(cat /tmp/web_targets.txt); do
      nikto -h "$url" -output /tmp/nikto_"$(echo $url | tr '/' '_')".txt
    done

  # Variables generated from asset properties
  variables:
    web_services_urls: "{asset.properties.web_services[].host}:{asset.properties.web_services[].port}"
    web_services_list: "/tmp/web_targets.txt"
```

---

## 🔄 **Trigger Lifecycle Management**

### **1. Trigger Detection**
```dart
class TriggerDetector {
  List<MethodologyTrigger> detectTriggersForAsset(Asset asset) {
    List<MethodologyTrigger> triggers = [];

    for (methodology in availableMethodologies) {
      if (methodology.triggerConditions.matches(asset.properties)) {
        String dedupKey = generateDeduplicationKey(methodology, asset);

        if (!isAlreadyCompleted(dedupKey)) {
          triggers.add(MethodologyTrigger(
            methodologyId: methodology.id,
            assetId: asset.id,
            deduplicationKey: dedupKey,
            triggerData: extractTriggerData(asset.properties)
          ));
        }
      }
    }

    return groupBatchableTriggersOrNo(triggers);
  }
}
```

### **2. Completion Tracking**
```dart
class TriggerCompletionTracker {
  Map<String, TriggerResult> completedTriggers = {};

  void markCompleted(String dedupKey, TriggerResult result) {
    completedTriggers[dedupKey] = result;
  }

  bool isCompleted(String dedupKey) {
    return completedTriggers.containsKey(dedupKey);
  }

  TriggerResult? getResult(String dedupKey) {
    return completedTriggers[dedupKey];
  }
}
```

### **3. Batch Grouping**
```dart
class BatchTriggerGrouper {
  List<BatchedTrigger> groupTriggers(List<MethodologyTrigger> triggers) {
    Map<String, List<MethodologyTrigger>> groups = {};

    for (trigger in triggers) {
      String batchKey = "${trigger.methodologyId}:${trigger.batchCriteria}";
      groups.putIfAbsent(batchKey, () => []).add(trigger);
    }

    return groups.entries.map((entry) =>
      BatchedTrigger(
        methodologyId: entry.key.split(':')[0],
        triggers: entry.value,
        batchCommand: generateBatchCommand(entry.value)
      )
    ).toList();
  }
}
```

---

## 🎮 **Real-World Scenarios**

### **Scenario 1: Corporate Network with NAC**
```yaml
# Initial asset state
network_segment:
  properties:
    subnet: "192.168.100.0/24"
    nac_enabled: true
    access_level: "blocked"
    credentials_available: []

# Triggers fired:
1. dhcp_auto_configuration (nac_enabled=false) → SKIPPED
2. mac_spoofing_nac_bypass (nac_enabled=true) → TRIGGERED
3. static_ip_configuration (dhcp_failed=true) → TRIGGERED

# After MAC spoofing succeeds:
network_segment:
  properties:
    access_level: "limited"  # Property updated
    bypass_methods_attempted: ["mac_spoofing"]

# New triggers fired:
1. network_discovery (access_level != "blocked") → TRIGGERED
2. port_scanning (network_access=true) → TRIGGERED
```

### **Scenario 2: Web Services Discovery & Enumeration**
```yaml
# Asset after network discovery
network_segment:
  properties:
    web_services: [
      {host: "192.168.1.10", port: 80, service: "nginx"},
      {host: "192.168.1.11", port: 80, service: "apache"},
      {host: "192.168.1.12", port: 443, service: "nginx", ssl: true},
      {host: "192.168.1.13", port: 8080, service: "tomcat"}
    ]

# Batch trigger generated:
web_service_enumeration:
  deduplication_key: "network_192_168_1_0:web_enum:4_services"
  batch_command: |
    # Screenshot all web services
    echo "http://192.168.1.10:80" > /tmp/web_targets.txt
    echo "http://192.168.1.11:80" >> /tmp/web_targets.txt
    echo "https://192.168.1.12:443" >> /tmp/web_targets.txt
    echo "http://192.168.1.13:8080" >> /tmp/web_targets.txt

    eyewitness --web -f /tmp/web_targets.txt -d /tmp/web_screenshots

    # Parallel vulnerability scanning
    parallel -j 4 "nikto -h {} -output /tmp/nikto_{#}.txt" :::: /tmp/web_targets.txt
```

### **Scenario 3: Credential Testing Across Multiple Services**
```yaml
# Asset with credentials and multiple targets
network_segment:
  properties:
    credentials_available: [
      {username: "admin", password: "Password123"},
      {username: "service", password: "ServicePass"}
    ]
    smb_hosts: ["192.168.1.10", "192.168.1.11"]
    rdp_hosts: ["192.168.1.12"]
    ssh_hosts: ["192.168.1.13"]

# Batch credential testing:
credential_testing:
  deduplication_key: "network_192_168_1_0:cred_test:2_creds_4_hosts"
  batch_command: |
    # Generate credential combinations
    for host in 192.168.1.10 192.168.1.11; do
      for cred in "admin:Password123" "service:ServicePass"; do
        echo "smbclient -L //$host -U $cred" >> /tmp/smb_tests.sh
      done
    done

    for host in 192.168.1.12; do
      for cred in "admin:Password123" "service:ServicePass"; do
        echo "xfreerdp /v:$host /u:${cred%:*} /p:${cred#*:} /cert-ignore +auth-only" >> /tmp/rdp_tests.sh
      done
    done

    # Execute tests in parallel
    parallel -j 5 < /tmp/smb_tests.sh
    parallel -j 5 < /tmp/rdp_tests.sh
```

---

## 🔧 **Implementation Requirements**

### **1. Enhanced Asset Property System**
- Rich property schema for different asset types
- Property update notifications
- Property change history tracking

### **2. Advanced Trigger Engine**
- Complex condition matching (AND, OR, NOT, comparisons)
- Deduplication key generation
- Batch grouping algorithms

### **3. Command Template System**
- Variable substitution from asset properties
- Batch command generation
- Multi-target command optimization

### **4. Completion Tracking Database**
- Persistent trigger completion storage
- Result caching and retrieval
- Performance analytics

---

## 🎯 **Benefits of This Approach**

1. **Realistic Attack Progression**: Triggers based on actual reconnaissance findings
2. **Efficiency**: Batch operations reduce tool invocations and time
3. **No Redundancy**: Intelligent deduplication prevents repeat work
4. **Scalability**: Handles large networks with many similar targets
5. **Intelligent Automation**: Combines multiple conditions into optimized commands
6. **Audit Trail**: Track exactly what combinations were attempted

This system transforms Madness from a step-by-step methodology executor into an intelligent attack orchestration platform that adapts to discovered network properties and optimizes its approach based on real-world conditions.