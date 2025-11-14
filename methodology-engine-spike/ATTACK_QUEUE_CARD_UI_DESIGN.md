# Attack Queue Card UI Design

## Overview

The Attack Queue displays atomic steps as interactive cards, organized by phase and category. Each card provides a high-level summary and expands to show detailed execution information, risks, and reporting guidance.

## Card Hierarchy

### Level 1: Category Cards (Summary View)
Cards group related atomic steps (e.g., "Host Discovery", "Port Scanning", "SSH Enumeration").

**Card Components:**
- **Title**: Category name (e.g., "Host Discovery")
- **Icon**: Phase-appropriate icon
- **Progress Summary**:
  - Completed: N targets/networks
  - Pending: N targets/networks
  - Ignored: N targets/networks
  - Failed: N targets/networks
- **Status Indicator**: Overall health (green/yellow/red)
- **Quick Actions**: Run All, Pause, Skip, Configure
- **Estimated Time**: Based on pending items and average execution time

**Example:**
```
┌─────────────────────────────────────────────┐
│ 🔍 Host Discovery                          │
│                                             │
│ ████████░░ 80% Complete                     │
│                                             │
│ ✓ 12 Completed  ⏳ 3 Pending  ⊘ 1 Ignored  │
│ ⏱ Est. 5 minutes remaining                  │
│                                             │
│ [▶ Run Pending] [⏸ Pause] [⚙ Configure]    │
└─────────────────────────────────────────────┘
```

### Level 2: Expanded Card View (Tabbed Interface)

When clicked, card expands to show detailed information in tabs:

#### Tab 1: Overview
- **Purpose**: What this step accomplishes
- **Triggers**: What causes this step to execute
- **Inputs**: Required asset properties
- **Outputs**: Assets created/updated
- **Dependencies**: Prerequisites and next steps
- **Estimated Duration**: Per target

#### Tab 2: Execution
- **Active Executions**: Currently running
  - Target, command, elapsed time, progress
  - Real-time output streaming
  - Pause/resume/cancel controls
- **Pending Queue**: Upcoming executions
  - Target list, priority, scheduled time
  - Batch grouping visualization
- **Command Options**: Alternate commands with selection
  - Platform-specific commands
  - Tool availability indicators
  - Preference selection
- **Configuration**: Step-specific parameters
  - Timeout, retry, cooldown settings
  - Custom command templates

#### Tab 3: Results
- **Completed Executions**: Historical results
  - Success/failure status
  - Execution time, exit code
  - Created/updated assets
  - Output/error logs
- **Summary Statistics**:
  - Success rate, average duration
  - Assets discovered
  - Errors encountered
- **Filters**: By status, target, time range

#### Tab 4: Risks & Issues
- **Security Risks**: What could go wrong
  - IDS/IPS detection likelihood
  - Network/service disruption potential
  - Legal/compliance concerns
- **Mitigation Strategies**: How to reduce risk
  - Timing recommendations
  - Alternative approaches
  - Communication with client
- **Common Issues**: Known problems and solutions
  - Error messages and fixes
  - Tool-specific quirks
  - Environment requirements
- **Troubleshooting**: Debug checklist

#### Tab 5: Findings
- **Expected Findings**: What to look for
  - Common discoveries
  - Security implications
- **Reporting Guidance**: How to document
  - Finding templates
  - Severity ratings
  - Remediation recommendations
- **Example Findings**: Sample report text
  - Critical/High/Medium/Low examples
  - Business impact descriptions

## Data Model

### Card Summary (Aggregated)
```json
{
  "category_id": "host_discovery",
  "category_name": "Host Discovery",
  "icon": "🔍",
  "phase": "discovery",
  "priority": 10,

  "summary": {
    "total_targets": 15,
    "completed": 12,
    "pending": 3,
    "ignored": 1,
    "failed": 0,
    "progress_percent": 80
  },

  "timing": {
    "estimated_remaining_seconds": 300,
    "average_execution_seconds": 120,
    "total_execution_seconds": 1440
  },

  "health_status": "good",  // good/warning/error
  "steps_included": ["host_discovery_icmp_ping_sweep", "host_discovery_arp_scan", ...]
}
```

### Enhanced Atomic Step Schema
```yaml
step:
  id: host_discovery_icmp_ping_sweep
  name: "ICMP Ping Sweep Discovery"
  description: "Discover live hosts using ICMP echo requests"

  # Existing fields...
  phase: discovery
  priority: 10
  trigger_conditions: [...]
  commands: [...]

  # NEW: UI/UX metadata
  ui_metadata:
    category: "Host Discovery"
    icon: "🔍"
    color: "#4CAF50"

  # NEW: Detailed overview
  overview:
    purpose: |
      Identifies live hosts on a network by sending ICMP echo requests (ping).
      This is typically the first step in network reconnaissance.

    when_to_use: |
      - Initial network mapping
      - When ICMP traffic is allowed
      - For quick host enumeration

    when_to_skip: |
      - ICMP is blocked by firewall
      - Stealth is critical (very noisy)
      - Time-sensitive engagements (slow on large networks)

    expected_outcomes:
      - "List of live hosts with IP addresses"
      - "Hostnames (if reverse DNS available)"
      - "MAC addresses and vendor info (local network)"

    typical_duration:
      per_target: "2-5 minutes per /24 network"
      factors: ["Network size", "Response time", "Packet loss"]

  # NEW: Risks and mitigation
  risks:
    - risk: "IDS/IPS Detection"
      severity: high
      likelihood: high
      description: |
        ICMP ping sweeps are easily detected by network security devices.
        Most IDS/IPS systems have signatures for ping sweep behavior.
      mitigation: |
        - Use slower timing (-T2 or --scan-delay)
        - Randomize target order
        - Combine with other discovery methods
        - Coordinate with client's security team

    - risk: "Network Congestion"
      severity: medium
      likelihood: low
      description: |
        Large-scale ping sweeps can cause network congestion on older
        infrastructure or saturated networks.
      mitigation: |
        - Use conservative timing templates
        - Scan during off-peak hours
        - Throttle packet rate
        - Test on small subnet first

    - risk: "Firewall Blocking"
      severity: low
      likelihood: high
      description: |
        Many networks block ICMP echo requests at the perimeter or
        on end hosts (Windows Firewall default).
      mitigation: |
        - Fall back to TCP SYN discovery
        - Try alternative ICMP types (timestamp, netmask)
        - Use ARP scan for local networks

  # NEW: Common issues
  common_issues:
    - issue: "No hosts discovered despite knowing they exist"
      symptoms:
        - "Nmap returns 0 hosts up"
        - "All hosts show as down"
      causes:
        - "ICMP blocked by firewall"
        - "Wrong network interface selected"
        - "VPN routing issues"
      solutions:
        - "Verify ICMP allowed: ping single known-good host"
        - "Check network interface: ip addr or ifconfig"
        - "Try TCP SYN discovery: nmap -sn -PS22,80,443"
        - "Use ARP scan for local subnet: nmap -sn -PR"

    - issue: "Scan extremely slow"
      symptoms:
        - "Takes hours for small subnet"
        - "Frequent timeouts"
      causes:
        - "High packet loss"
        - "Rate limiting"
        - "Poor network quality"
      solutions:
        - "Reduce timing: nmap -sn -T2"
        - "Increase timeout: --host-timeout 10m"
        - "Test network quality first"

    - issue: "Permission denied / Operation not permitted"
      symptoms:
        - "Nmap error about raw sockets"
        - "Command fails to start"
      causes:
        - "Insufficient privileges"
        - "Capabilities not set"
      solutions:
        - "Run with sudo"
        - "Set capabilities: sudo setcap cap_net_raw,cap_net_admin+eip /usr/bin/nmap"

  # NEW: Findings and reporting
  findings:
    categories:
      - "Information Disclosure"
      - "Network Mapping"

    expected_discoveries:
      - finding_type: "Live Hosts Identified"
        severity: informational
        description: "Network reconnaissance identified live hosts"
        report_template: |
          ## Live Host Discovery

          **Severity**: Informational

          **Description**:
          Network reconnaissance using ICMP echo requests identified {count} live
          hosts on the {network} network. This information provides a map of active
          systems that can be further enumerated.

          **Hosts Discovered**:
          {host_list}

          **Security Impact**:
          While not a vulnerability itself, network visibility enables attackers to
          identify targets for further exploitation. This is a standard reconnaissance
          technique used in the early stages of an attack.

          **Recommendation**:
          - Implement network segmentation to limit reconnaissance scope
          - Consider host-based firewalls to block ICMP on sensitive systems
          - Monitor for reconnaissance activity using IDS/IPS
          - Document legitimate scanning sources to distinguish from attacks

      - finding_type: "ICMP Responses Allowed"
        severity: low
        description: "Hosts respond to ICMP echo requests"
        report_template: |
          ## ICMP Echo Responses Enabled

          **Severity**: Low

          **Description**:
          Hosts on the {network} network respond to ICMP echo requests (ping),
          allowing attackers to quickly enumerate live systems. {count} hosts were
          discovered using this technique.

          **Security Impact**:
          ICMP responses facilitate network reconnaissance by:
          - Revealing live hosts quickly and easily
          - Providing response time data for network topology inference
          - Enabling OS fingerprinting through TTL and packet analysis

          **Recommendation**:
          Consider blocking ICMP echo requests at the perimeter firewall and on
          internal host firewalls, especially for sensitive systems. Note that this
          may impact network troubleshooting tools.

          **Note**: This is a defense-in-depth measure. Determined attackers can
          use TCP/UDP discovery methods even if ICMP is blocked.

      - finding_type: "Internal Network Structure Revealed"
        severity: medium
        when: "hostname_patterns_detected"
        description: "Hostname patterns reveal network organization"
        report_template: |
          ## Internal Network Structure Disclosure

          **Severity**: Medium

          **Description**:
          Reverse DNS lookups revealed consistent hostname patterns that disclose
          internal network organization and server purposes. Examples:

          {example_hostnames}

          **Security Impact**:
          Hostname patterns provide attackers with:
          - Server roles and purposes (db01, web02, dc-prod)
          - Network segmentation strategy
          - Naming conventions for targeted guessing
          - Priority targets (database, domain controllers)

          **Recommendation**:
          - Use non-descriptive hostnames for external-facing DNS
          - Implement split-horizon DNS
          - Limit reverse DNS information for sensitive systems
          - Consider randomized or obfuscated naming schemes
```

## Implementation Notes

### Card Aggregation Logic
```python
def aggregate_category_summary(category_steps, executions):
    """Aggregate atomic step executions into category card summary."""

    targets = set()
    completed = 0
    pending = 0
    failed = 0
    ignored = 0

    for execution in executions:
        if execution.step_id in category_steps:
            targets.add(execution.asset_id)

            if execution.status == "completed":
                completed += 1
            elif execution.status == "pending":
                pending += 1
            elif execution.status == "failed":
                failed += 1
            elif execution.status == "ignored":
                ignored += 1

    return {
        "total_targets": len(targets),
        "completed": completed,
        "pending": pending,
        "failed": failed,
        "ignored": ignored,
        "progress_percent": (completed / len(targets) * 100) if targets else 0
    }
```

### Health Status Determination
```python
def calculate_health_status(summary):
    """Determine card health status based on summary."""

    if summary["failed"] > 0:
        failure_rate = summary["failed"] / summary["total_targets"]
        if failure_rate > 0.5:
            return "error"
        elif failure_rate > 0.1:
            return "warning"

    if summary["progress_percent"] < 20 and summary["pending"] > 0:
        return "warning"  # Stalled

    return "good"
```

## UI Framework Recommendations

### Flutter Widgets
- **Card**: ExpansionTile or custom animated container
- **Tabs**: TabBar / TabBarView
- **Progress**: LinearProgressIndicator with custom styling
- **Real-time updates**: StreamBuilder connected to execution engine

### Key Features
- Smooth expand/collapse animations
- Real-time execution updates
- Keyboard shortcuts (space to expand, arrow keys to navigate)
- Search/filter across all cards
- Export results per category
- Bulk actions (run all pending, clear completed)

## Category Groupings

Suggested category cards:

**Discovery Phase:**
- Host Discovery (ICMP, ARP, TCP SYN, UDP)
- Domain Discovery (DNS, subdomain enum)

**Scanning Phase:**
- Port Scanning (quick, full, UDP, version)

**Identification Phase:**
- Service Identification (banner, NSE, SSL/TLS)

**Enumeration Phase (per service):**
- SSH Enumeration
- HTTP Enumeration
- SMB Enumeration
- Database Enumeration
- FTP Enumeration
- ... (one card per service type)

**Exploitation Phase:**
- Password Attacks
- Vulnerability Exploitation
- Privilege Escalation

**Post-Exploitation:**
- Credential Harvesting
- Lateral Movement
- Persistence
