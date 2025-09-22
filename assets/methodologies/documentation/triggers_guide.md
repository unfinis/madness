# Methodology Trigger System Documentation

## Overview

The methodology trigger system automatically suggests and executes methodologies based on discovered assets and their properties. This document explains how to create effective triggers for your methodologies.

## Trigger Types

### Simple Triggers

Simple triggers use straightforward asset property matching:

```json
{
  "name": "windows_smb_host",
  "type": "simple",
  "conditions": {
    "asset_type": "host",
    "properties": {
      "os_type": "windows",
      "services": [{"service_name": "smb"}]
    }
  },
  "description": "Trigger for Windows hosts with SMB service"
}
```

### Complex Triggers

Complex triggers use JavaScript expressions for advanced logic:

```json
{
  "name": "vulnerable_web_server",
  "type": "complex",
  "script": "asset.type === 'service' && asset.properties.service_name === 'http' && asset.properties.vulnerabilities && asset.properties.vulnerabilities.some(v => v.severity === 'high')",
  "description": "Web servers with high-severity vulnerabilities"
}
```

## Available Asset Types

### Network Segment Assets
- **Type**: `networkSegment`
- **Use Case**: Network-wide testing, NAC bypass, VLAN testing

### Host Assets
- **Type**: `host`
- **Use Case**: Host-specific attacks, privilege escalation, lateral movement

### Service Assets
- **Type**: `service`
- **Use Case**: Service-specific attacks, exploitation, enumeration

### Wireless Network Assets
- **Type**: `wireless_network`
- **Use Case**: Wireless attacks, WPA cracking, evil twin

### Credential Assets
- **Type**: `credential`
- **Use Case**: Password attacks, credential testing, authentication bypass

## Asset Property Reference

### Network Segment Properties

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `subnet` | string | Network subnet | "192.168.1.0/24" |
| `gateway` | string | Gateway IP | "192.168.1.1" |
| `vlan_id` | integer | VLAN identifier | 100 |
| `nac_enabled` | boolean | NAC presence | true |
| `nac_type` | string | NAC type | "802.1x", "mac_auth" |
| `access_level` | string | Access level | "blocked", "limited", "partial", "full" |
| `dhcp_servers` | stringList | DHCP server IPs | ["192.168.1.1"] |
| `dns_servers` | stringList | DNS server IPs | ["8.8.8.8", "8.8.4.4"] |
| `domain_name` | string | Domain name | "corp.local" |
| `firewall_present` | boolean | Firewall detected | true |
| `ips_ids_present` | boolean | IPS/IDS detected | false |
| `live_hosts` | stringList | Discovered hosts | ["192.168.1.10", "192.168.1.20"] |
| `web_services` | objectList | Web services found | [{"host": "192.168.1.10", "port": 80}] |
| `smb_hosts` | stringList | SMB-enabled hosts | ["192.168.1.10"] |
| `credentials_available` | objectList | Available credentials | [{"username": "admin", "password": "pass123"}] |

### Host Properties

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `ip_address` | string | IPv4 address | "192.168.1.10" |
| `ipv6_address` | string | IPv6 address | "fe80::1" |
| `hostname` | string | Host name | "SERVER01" |
| `mac_address` | string | MAC address | "00:11:22:33:44:55" |
| `os_type` | string | Operating system | "windows", "linux", "macos" |
| `os_version` | string | OS version | "Windows Server 2019" |
| `os_architecture` | string | Architecture | "x64", "x86" |
| `open_ports` | stringList | Open ports | ["22", "80", "443"] |
| `services` | objectList | Running services | [{"port": 80, "service": "http"}] |
| `smb_signing` | boolean | SMB signing enabled | false |
| `rdp_enabled` | boolean | RDP service active | true |
| `ssh_enabled` | boolean | SSH service active | true |
| `privilege_level` | string | Access level | "none", "user", "admin", "system" |
| `vulnerabilities` | objectList | Known vulnerabilities | [{"cve": "CVE-2021-1234", "severity": "high"}] |

### Service Properties

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `host` | string | Host IP/name | "192.168.1.10" |
| `port` | integer | Service port | 80 |
| `protocol` | string | Protocol | "tcp", "udp" |
| `service_name` | string | Service name | "http", "smb", "ssh" |
| `version` | string | Service version | "Apache 2.4.41" |
| `banner` | string | Service banner | "SSH-2.0-OpenSSH_7.4" |
| `ssl_enabled` | boolean | SSL/TLS enabled | true |
| `authentication_required` | boolean | Auth required | true |
| `default_credentials` | boolean | Default creds | false |

### Wireless Network Properties

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `ssid` | string | Network name | "CorpWiFi" |
| `bssid` | string | Access point MAC | "aa:bb:cc:dd:ee:ff" |
| `encryption` | string | Encryption type | "wpa2", "wpa3", "open" |
| `channel` | integer | WiFi channel | 6 |
| `signal_strength` | integer | Signal strength | -45 |
| `wps_enabled` | boolean | WPS enabled | false |
| `guest_network` | boolean | Guest network | true |
| `captive_portal` | boolean | Portal present | true |

## Trigger Condition Operators

### Equality
```json
{
  "asset_type": "host",
  "properties": {
    "os_type": "windows"
  }
}
```

### List Contains
```json
{
  "properties": {
    "open_ports": ["22", "80"]
  }
}
```

### Existence Check
```json
{
  "properties": {
    "vulnerabilities": {"exists": true}
  }
}
```

### Value In List
```json
{
  "properties": {
    "vlan_id": {"in": [10, 20, 30]}
  }
}
```

### Nested Object Queries
```json
{
  "properties": {
    "services": [
      {
        "service_name": "http",
        "ssl_enabled": false
      }
    ]
  }
}
```

## Complex Trigger Examples

### Multi-Condition Logic
```javascript
// Windows hosts with SMB and available credentials
asset.type === 'host' &&
asset.properties.os_type === 'windows' &&
asset.properties.services.some(s => s.service_name === 'smb') &&
context.credentials.some(c => c.domain === asset.properties.domain_name)
```

### Network Segmentation Testing
```javascript
// Segmented networks with bypassed access controls
asset.type === 'networkSegment' &&
asset.properties.vlan_id &&
asset.properties.access_level === 'full' &&
asset.properties.bypass_methods_successful &&
asset.properties.bypass_methods_successful.length > 0
```

### Vulnerability-Based Triggers
```javascript
// Services with exploitable vulnerabilities
asset.type === 'service' &&
asset.properties.vulnerabilities &&
asset.properties.vulnerabilities.some(v =>
  v.severity === 'high' && v.exploitable === true
)
```

### Time-Based Conditions
```javascript
// Recently discovered assets (last 24 hours)
asset.type === 'host' &&
(Date.now() - new Date(asset.discoveredAt).getTime()) < 86400000
```

## Context Variables

Triggers have access to context variables:

### Available Context
- `asset` - Current asset being evaluated
- `context.credentials` - Available credentials
- `context.project` - Current project info
- `context.assets` - All project assets
- `context.time` - Current timestamp

### Context Usage Examples
```javascript
// Check if credentials exist for this domain
context.credentials.some(c => c.domain === asset.properties.domain_name)

// Find related assets
context.assets.filter(a =>
  a.properties.subnet === asset.properties.subnet
)

// Time-based logic
context.time.getHours() >= 9 && context.time.getHours() <= 17
```

## Trigger Best Practices

### 1. Be Specific
```json
// Good - Specific conditions
{
  "conditions": {
    "asset_type": "host",
    "properties": {
      "os_type": "windows",
      "smb_signing": false,
      "null_sessions": true
    }
  }
}

// Avoid - Too broad
{
  "conditions": {
    "asset_type": "host"
  }
}
```

### 2. Consider Prerequisites
```json
{
  "script": "asset.type === 'service' && asset.properties.service_name === 'ssh' && context.credentials.length > 0",
  "description": "SSH service with available credentials for testing"
}
```

### 3. Avoid Conflicts
```json
// Use deduplication keys to prevent duplicate execution
{
  "script": "asset.type === 'host' && !asset.completedTriggers.includes('smb_enumeration_' + asset.id)"
}
```

### 4. Document Clearly
```json
{
  "name": "windows_domain_controller",
  "description": "Windows domain controllers for AD enumeration and privilege escalation testing",
  "conditions": {
    "asset_type": "host",
    "properties": {
      "os_type": "windows",
      "services": [{"service_name": "ldap"}],
      "domain_controller": true
    }
  }
}
```

## Testing Triggers

### Manual Testing
Use the trigger evaluation service to test trigger logic:

```javascript
// Test trigger against sample asset
const asset = {
  type: 'host',
  properties: {
    os_type: 'windows',
    services: [{service_name: 'smb'}]
  }
};

const result = evaluateTrigger(triggerDefinition, asset, context);
console.log('Trigger matches:', result);
```

### Common Issues

1. **Property Type Mismatches**
   - Ensure string/number/boolean types match
   - Check array vs object property access

2. **Missing Properties**
   - Use existence checks before accessing nested properties
   - Provide fallback values for optional properties

3. **Complex Logic Errors**
   - Test JavaScript expressions in isolation
   - Use console.log for debugging complex triggers

## Trigger Categories

### Discovery Triggers
- New asset discovery
- Service enumeration
- Network mapping

### Vulnerability Triggers
- CVE-specific exploits
- Configuration weaknesses
- Default credentials

### Access Triggers
- Privilege escalation
- Lateral movement
- Persistence mechanisms

### Bypass Triggers
- Authentication bypass
- Network controls bypass
- Security control evasion

## Methodology Integration

Triggers automatically execute methodologies when conditions are met:

1. **Asset Discovery** → Trigger evaluation
2. **Trigger Match** → Methodology queued
3. **Execution** → Results processed
4. **New Assets** → Trigger re-evaluation

This creates an automated penetration testing workflow based on discovered assets and their properties.