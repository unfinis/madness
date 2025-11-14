# Attack Queue: Atomic Step Architecture

## Overview

The attack queue uses atomic, state-driven steps where asset changes trigger appropriate next actions. This creates a natural progression through pentesting phases.

## Step Hierarchy

### Phase 1: Discovery
**Trigger**: User adds target subnet or IP range
**Steps**:
- `host_discovery_ping_sweep` - ICMP ping sweep
- `host_discovery_arp_scan` - ARP scan (local network)
- `host_discovery_tcp_syn` - TCP SYN ping (common ports)
- `host_discovery_udp` - UDP discovery
- `host_discovery_dns_ptr` - Reverse DNS lookups

**Output**: Creates `Host` assets with properties:
```yaml
asset_type: host
properties:
  ip: "10.0.0.50"
  hostname: "server01.example.com"
  state: "up"
  discovery_method: "icmp_ping"
  os_hint: null
```

### Phase 2: Port Scanning
**Trigger**: New `Host` asset created with `state: up`
**Steps**:
- `port_scan_quick` - Top 1000 ports (nmap -F)
- `port_scan_full` - All 65535 ports (nmap -p-)
- `port_scan_udp_common` - Common UDP ports
- `port_scan_version` - Version detection on found ports

**Output**: Creates `Port` assets with properties:
```yaml
asset_type: port
parent: host_id
properties:
  port: 22
  protocol: "tcp"
  state: "open"
  service: null  # Not yet identified
```

### Phase 3: Service Identification
**Trigger**: New `Port` asset with `state: open` and `service: null`
**Steps**:
- `service_id_banner_grab` - Simple banner grabbing
- `service_id_nmap_version` - nmap -sV on specific port
- `service_id_manual_probes` - Protocol-specific probes
- `service_id_ssl_inspection` - SSL certificate parsing (if TLS)

**Output**: Updates `Port` asset with service info:
```yaml
asset_type: port
properties:
  port: 22
  protocol: "tcp"
  state: "open"
  service: "ssh"
  version: "OpenSSH 8.2p1 Ubuntu-4ubuntu0.5"
  banner: "SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5"
```

### Phase 4: Service Enumeration
**Trigger**: `Port` asset with identified `service` type
**Steps**: Service-specific enumeration (broken down atomically)

#### Example: SSH Service
- `ssh_enum_methods` - Enumerate auth methods
- `ssh_enum_algorithms` - Cipher/MAC/KEX algorithms
- `ssh_user_enum_timing` - Username enumeration via timing
- `ssh_user_enum_cve` - CVE-2018-15473 user enum
- `ssh_key_exchange_info` - Key exchange information

#### Example: HTTP Service
- `http_tech_identification` - Technology fingerprinting (whatweb)
- `http_waf_detection` - WAF detection (wafw00f)
- `http_initial_checks` - robots.txt, sitemap.xml
- `http_screenshot` - Visual screenshot (eyewitness)
- `http_ssl_scan` - SSL/TLS scan (if HTTPS)

**Output**: Enriches `Port` asset with enumeration data:
```yaml
properties:
  service: "ssh"
  version: "OpenSSH 8.2p1"
  ssh_auth_methods: ["publickey", "password"]
  ssh_allows_password_auth: true
  ssh_vulnerable_to_user_enum: true
```

### Phase 5: Vulnerability Assessment
**Trigger**: Enriched service properties matching vulnerability patterns
**Steps**:
- `vuln_scan_nmap_scripts` - Nmap vuln scripts
- `vuln_scan_nuclei` - Nuclei templates
- `vuln_cve_check` - CVE database lookup by version
- `vuln_default_creds` - Default credential testing

### Phase 6: Exploitation
**Trigger**: Identified vulnerabilities or weak configurations
**Steps**:
- `exploit_brute_force` - Credential brute forcing
- `exploit_known_cve` - Known CVE exploitation
- `exploit_misconfig` - Misconfiguration exploitation

## Trigger System Design

### Trigger Types

1. **Asset Creation Trigger**
```yaml
trigger_type: asset_created
conditions:
  asset_type: subnet
actions:
  - step: host_discovery_ping_sweep
    priority: 10
```

2. **Property Match Trigger**
```yaml
trigger_type: property_match
conditions:
  asset_type: host
  properties:
    state: "up"
    ports_scanned: { $ne: true }
actions:
  - step: port_scan_quick
    priority: 8
```

3. **Property Update Trigger**
```yaml
trigger_type: property_updated
conditions:
  asset_type: port
  properties:
    state: "open"
    service: null
actions:
  - step: service_id_banner_grab
    priority: 7
```

4. **Service Type Trigger**
```yaml
trigger_type: service_identified
conditions:
  service: "ssh"
  version: { $regex: "OpenSSH [0-7]\\." }  # Older versions
actions:
  - step: ssh_user_enum_cve
    priority: 6
  - step: ssh_enum_methods
    priority: 5
```

### Deduplication Strategy

Each step execution is tracked:
```yaml
step_execution:
  id: "uuid"
  step_id: "host_discovery_ping_sweep"
  asset_id: "subnet_10.0.0.0_24"
  signature: "sha256(step_id + asset_id + relevant_properties)"
  status: "completed"  # pending, in_progress, completed, failed
  timestamp: "2024-01-15T10:30:00Z"
  result:
    hosts_found: 15
    new_assets_created: [host_ids...]
```

## Step Priority System

Priority levels (higher = more urgent):
- **10**: Discovery (user-initiated)
- **9**: Critical service identification (known exploit available)
- **8**: Port scanning (prerequisite for everything)
- **7**: Service identification
- **6**: High-value service enumeration (SSH, RDP, HTTP)
- **5**: Medium-value service enumeration
- **4**: Low-value service enumeration
- **3**: Vulnerability scanning
- **2**: Exploitation attempts
- **1**: Post-exploitation

## Batch Processing

Steps with the same priority and type can be batched:

```yaml
batch_execution:
  step: "port_scan_quick"
  targets:
    - host: "10.0.0.1"
    - host: "10.0.0.2"
    - host: "10.0.0.3"
  command: "nmap -F 10.0.0.1 10.0.0.2 10.0.0.3"
  execution_mode: "parallel"
```

## Step Definition Structure

```yaml
step:
  id: "host_discovery_ping_sweep"
  name: "Host Discovery - ICMP Ping Sweep"
  phase: "discovery"

  trigger:
    type: "asset_created"
    conditions:
      asset_type: "subnet"

  prerequisites:
    - asset_property: "cidr"

  commands:
    - tool: "nmap"
      command: "nmap -sn -PE -PP {cidr}"
      platforms: ["linux", "macos", "windows"]
      timeout: 300
      parse_output: true

  output_parser:
    type: "nmap_xml"
    creates_assets:
      - type: "host"
        extract:
          ip: "//host/@addr"
          state: "//host/status/@state"
          hostname: "//host/hostnames/hostname/@name"

  next_steps:
    - trigger: "port_scan_quick"
      condition: "created_assets.count > 0"

  deduplication:
    signature_fields: ["asset_id", "step_id"]
    timeout: 3600  # Don't repeat within 1 hour

  priority: 10
  batch_compatible: true
  max_batch_size: 256
```

## Queue Management

### Queue Entry
```yaml
queue_entry:
  id: "uuid"
  step_id: "port_scan_quick"
  asset_id: "host_10.0.0.50"
  priority: 8
  status: "pending"
  created_at: "2024-01-15T10:30:00Z"
  scheduled_at: "2024-01-15T10:30:05Z"  # Slight delay for batching
  attempts: 0
  max_attempts: 3
  metadata:
    triggered_by: "step_execution_uuid"
    parent_asset: "subnet_id"
```

### Queue Processing Logic

1. **Dequeue by Priority**: Highest priority first
2. **Batch Similar Steps**: Wait 5 seconds to collect similar steps
3. **Execute**: Run step with timeout
4. **Parse Output**: Extract new assets/properties
5. **Update Assets**: Store results in database
6. **Trigger Next Steps**: Evaluate what new steps should be queued
7. **Handle Failures**: Retry with exponential backoff

## Example Attack Flow

```
User Action: Add subnet 10.0.0.0/24
  ↓
[Queue] host_discovery_ping_sweep (priority: 10)
  ↓
[Execute] nmap -sn -PE 10.0.0.0/24
  ↓
[Result] Found 15 hosts
  ↓
[Create Assets] 15 Host objects
  ↓
[Trigger] 15 × port_scan_quick (priority: 8)
  ↓
[Batch] nmap -F 10.0.0.1-15 (batched execution)
  ↓
[Result] Found 47 open ports across 15 hosts
  ↓
[Create Assets] 47 Port objects (service: null)
  ↓
[Trigger] 47 × service_id_banner_grab (priority: 7)
  ↓
[Execute] Parallel banner grabbing
  ↓
[Result] Identified 32 services, 15 need deeper probing
  ↓
[Update Assets] Port objects with service types
  ↓
[Trigger] Service-specific enumeration steps
  - 5 × ssh_enum_methods (SSH services found)
  - 3 × http_tech_identification (HTTP services found)
  - 2 × rdp_enum_security (RDP services found)
  - etc.
```

## Benefits of Atomic Steps

1. **Granular Progress Tracking**: See exactly what's happening
2. **Better Resource Management**: Control parallelism per step type
3. **Intelligent Prioritization**: Critical findings jump the queue
4. **Flexible Workflows**: Easy to add/remove steps
5. **Better Error Handling**: Retry individual steps, not entire methodologies
6. **State Persistence**: Resume after crashes
7. **User Control**: Pause specific step types, adjust priorities
8. **Realistic Progression**: Mirrors actual pentesting workflow

## Migration from Current Methodology Structure

Current methodology steps can be decomposed:

**Before** (Monolithic):
```yaml
methodology: ssh_pentesting
steps:
  - banner_grab
  - auth_method_enum
  - user_enum
  - brute_force
  - known_exploits
```

**After** (Atomic):
```yaml
# Each becomes a separate step with its own trigger
step: ssh_banner_grab
  trigger: { service: "ssh", banner: null }

step: ssh_auth_method_enum
  trigger: { service: "ssh", auth_methods: null }

step: ssh_user_enum_timing
  trigger: { service: "ssh", version: { $regex: "OpenSSH" } }

step: ssh_brute_force
  trigger: { service: "ssh", allows_password_auth: true, credentials: null }
```

## Next Actions

1. Define all atomic steps for core phases (discovery → exploitation)
2. Create trigger engine to evaluate asset changes
3. Build queue management system with priority handling
4. Implement output parsers for common tools
5. Create asset update system that triggers next steps
6. Build batch execution engine
7. Add user controls (pause, prioritize, filter steps)
