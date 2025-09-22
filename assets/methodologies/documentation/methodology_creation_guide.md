# Methodology Creation Guide

## Overview

This guide provides comprehensive instructions for creating JSON methodology templates for the penetration testing framework. Follow these guidelines to ensure consistency, quality, and compatibility across all methodologies.

## File Structure

### Directory Organization
```
assets/methodologies/
├── web_applications/          # Web application testing
├── thick_clients/            # Desktop application testing
├── av_edr_evasion/          # Antivirus/EDR bypass techniques
├── breakout_testing/         # Sandbox/container breakout
├── network_testing/          # Network infrastructure testing
├── active_directory/         # AD enumeration and attacks
├── wireless_testing/         # WiFi and wireless security
├── site_testing/            # Physical site security
├── network_segregation/      # Network access control testing
├── build_reviews/           # Secure development reviews
├── mobile_applications/      # Mobile app security testing
├── container_breakout/       # Container security testing
├── azure_testing/           # Azure cloud security testing
└── documentation/           # Guides and references
```

### File Naming Convention
- Use descriptive, kebab-case names
- Include sequence numbers for logical ordering
- Example: `01_nac_bypass_comprehensive.json`

## JSON Schema Structure

### Required Root Fields

```json
{
  "id": "unique_methodology_identifier",
  "version": "1.0.0",
  "template_version": "1.0",
  "name": "Human Readable Methodology Name",
  "workstream": "directory_name",
  "author": "Team or Individual Name",
  "created": "2024-01-15T00:00:00Z",
  "modified": "2024-01-15T00:00:00Z",
  "status": "active|deprecated|draft",
  "description": "Detailed description of methodology purpose and scope",
  "tags": ["tag1", "tag2", "tag3"],
  "risk_level": "low|medium|high|critical"
}
```

### Field Descriptions

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `id` | string | Unique identifier (no spaces) | "nac_bypass_comprehensive" |
| `version` | string | Semantic version of content | "1.2.0" |
| `template_version` | string | JSON schema version | "1.0" |
| `name` | string | Display name | "NAC Bypass Methodology" |
| `workstream` | string | Directory name (no spaces) | "network_segregation" |
| `author` | string | Creator/maintainer | "Network Testing Team" |
| `created` | string | ISO 8601 creation date | "2024-01-15T00:00:00Z" |
| `modified` | string | ISO 8601 last modified | "2024-03-20T10:30:00Z" |
| `status` | string | Current status | "active" |
| `description` | string | Comprehensive description | See examples below |
| `tags` | array | Search tags | ["nac", "bypass", "802.1x"] |
| `risk_level` | string | Execution risk level | "medium" |

## Content Sections

### Overview Section

```json
"overview": {
  "purpose": "Clear statement of methodology objectives",
  "scope": "What systems/services are in scope for testing",
  "prerequisites": [
    "Required access levels",
    "Required tools",
    "Required knowledge"
  ],
  "category": "High-level category classification"
}
```

### Triggers Section

Define when this methodology should be executed:

```json
"triggers": [
  {
    "name": "descriptive_trigger_name",
    "type": "simple|complex",
    "conditions": {
      "asset_type": "networkSegment|host|service|wireless_network",
      "properties": {
        "property_name": "expected_value"
      }
    },
    "script": "JavaScript expression for complex triggers",
    "description": "When this trigger should activate"
  }
]
```

### Equipment Section

List physical equipment required:

```json
"equipment": [
  "Network interface (Ethernet/WiFi adapter)",
  "USB-to-Ethernet adapter",
  "WiFi adapter with monitor mode support",
  "Network cables",
  "Hardware security tokens"
]
```

### Procedures Section

Core methodology steps:

```json
"procedures": [
  {
    "id": "unique_procedure_id",
    "name": "Procedure Display Name",
    "description": "Detailed explanation of what this procedure accomplishes",
    "risk_level": "low|medium|high|critical",
    "risks": [
      {
        "risk": "Description of potential risk",
        "mitigation": "Steps to minimize or avoid the risk"
      }
    ],
    "commands": [
      {
        "tool": "command_tool_name",
        "command": "actual command with {parameters}",
        "description": "What this command does",
        "parameters": {
          "parameter_name": "Description of parameter"
        },
        "platforms": ["linux", "windows", "macos"]
      }
    ]
  }
]
```

### Findings Section

Expected vulnerability findings:

```json
"findings": [
  {
    "title": "Finding Title",
    "severity": "Low|Medium|High|Critical",
    "description": "Detailed finding description with evidence",
    "recommendation": "Specific remediation steps"
  }
]
```

### Cleanup Section

Post-testing cleanup steps:

```json
"cleanup": [
  {
    "step": "cleanup_step_id",
    "description": "What needs to be cleaned up",
    "command": "Command to execute cleanup"
  }
]
```

### Troubleshooting Section

Common issues and solutions:

```json
"troubleshooting": [
  {
    "issue": "Description of common problem",
    "solution": "Step-by-step solution"
  }
]
```

## Writing Guidelines

### Description Best Practices

**Good Description:**
```json
"description": "Comprehensive methodology for bypassing Network Access Control (NAC) systems using various techniques including DHCP exploitation, static IP configuration, MAC spoofing, 802.1X bypass, VLAN hopping, and wireless attacks. Suitable for testing enterprise network segmentation controls."
```

**Poor Description:**
```json
"description": "NAC bypass testing"
```

### Command Documentation

**Good Command:**
```json
{
  "tool": "nmap",
  "command": "nmap -sS -p {ports} -T4 --open {target_network}",
  "description": "Perform TCP SYN scan to discover open services on target network",
  "parameters": {
    "ports": "Port range to scan (e.g., 1-1000, 22,80,443)",
    "target_network": "Target IP range (e.g., 192.168.1.0/24)"
  },
  "platforms": ["linux", "macos"]
}
```

**Poor Command:**
```json
{
  "tool": "nmap",
  "command": "nmap -sS 192.168.1.0/24",
  "description": "Scan network"
}
```

### Risk Documentation

**Good Risk Entry:**
```json
{
  "risk": "Network monitoring systems may detect port scanning activity and trigger security alerts",
  "mitigation": "Use randomized timing with -T2 or -T3 options, scan during business hours to blend with normal traffic, and coordinate with SOC team if testing is authorized"
}
```

**Poor Risk Entry:**
```json
{
  "risk": "Might be detected",
  "mitigation": "Be careful"
}
```

## Versioning Strategy

### Semantic Versioning
- **MAJOR.MINOR.PATCH** format
- **MAJOR**: Breaking changes to methodology structure
- **MINOR**: New procedures, commands, or significant enhancements
- **PATCH**: Bug fixes, documentation updates, minor corrections

### Version Update Scenarios

| Change Type | Version Update | Example |
|-------------|---------------|---------|
| Fix typo in command | 1.0.0 → 1.0.1 | Documentation correction |
| Add new procedure | 1.0.1 → 1.1.0 | New bypass technique |
| Restructure methodology | 1.1.0 → 2.0.0 | Change trigger system |

### Template Version
Update `template_version` only when the JSON schema changes:
- Add new required fields
- Change field types or structure
- Modify validation rules

## Quality Assurance

### Pre-Submission Checklist

#### Content Quality
- [ ] All required fields present
- [ ] Descriptive and accurate naming
- [ ] Comprehensive procedure documentation
- [ ] Risk assessment completed
- [ ] Cleanup procedures defined
- [ ] Troubleshooting guide included

#### Technical Quality
- [ ] Valid JSON syntax
- [ ] Commands tested on target platforms
- [ ] Parameters properly documented
- [ ] Triggers validated against asset model
- [ ] Version numbers follow semantic versioning

#### Security Considerations
- [ ] Legal/authorization requirements documented
- [ ] Risk levels accurately assessed
- [ ] Mitigation strategies provided
- [ ] Cleanup procedures comprehensive
- [ ] No hardcoded credentials or sensitive data

### Validation Tools

Use the methodology validator before submission:

```javascript
// Validate methodology JSON
const isValid = MethodologyLoader.validateMethodology(methodologyJson);
if (!isValid) {
  console.log('Validation failed - check schema compliance');
}
```

## Common Patterns

### Network Testing Pattern
```json
{
  "triggers": [
    {
      "name": "network_access_gained",
      "type": "simple",
      "conditions": {
        "asset_type": "networkSegment",
        "properties": {
          "access_level": "partial"
        }
      }
    }
  ],
  "procedures": [
    {
      "id": "network_enumeration",
      "name": "Network Service Discovery",
      "risk_level": "low",
      "commands": [
        {
          "tool": "nmap",
          "command": "nmap -sn {network_range}",
          "description": "Discover live hosts"
        }
      ]
    }
  ]
}
```

### Service Testing Pattern
```json
{
  "triggers": [
    {
      "name": "web_service_detected",
      "type": "simple",
      "conditions": {
        "asset_type": "service",
        "properties": {
          "service_name": "http"
        }
      }
    }
  ],
  "procedures": [
    {
      "id": "web_enumeration",
      "name": "Web Application Enumeration",
      "risk_level": "low"
    }
  ]
}
```

### Credential Testing Pattern
```json
{
  "triggers": [
    {
      "name": "credentials_available",
      "type": "complex",
      "script": "asset.type === 'service' && context.credentials.length > 0"
    }
  ]
}
```

## Integration Examples

### Asset Property Integration
```json
{
  "triggers": [
    {
      "conditions": {
        "asset_type": "networkSegment",
        "properties": {
          "nac_enabled": true,
          "nac_type": "802.1x",
          "access_level": "blocked"
        }
      }
    }
  ]
}
```

### Multi-Asset Coordination
```javascript
// Complex trigger for coordinated attacks
"script": "asset.type === 'host' && asset.properties.os_type === 'windows' && context.assets.some(a => a.type === 'credential' && a.properties.username && a.properties.domain === asset.properties.domain_name)"
```

## Maintenance Guidelines

### Regular Updates
- Review methodologies quarterly
- Update commands for new tool versions
- Refresh risk assessments
- Add new troubleshooting scenarios

### Deprecation Process
1. Mark status as "deprecated"
2. Document replacement methodology
3. Provide migration timeline
4. Archive after grace period

### Collaboration
- Use Git for version control
- Create feature branches for major changes
- Require peer review for methodology updates
- Document all changes in version history

## Examples Repository

See the following example methodologies:
- `network_segregation/01_nac_bypass_comprehensive.json` - Complete NAC testing
- `web_applications/01_basic_web_enumeration.json` - Web app discovery
- `active_directory/01_domain_enumeration.json` - AD reconnaissance

Each example demonstrates best practices for their respective testing domains.