# Penetration Testing Asset Model - Python Spike

This is a comprehensive Python implementation of the penetration testing asset model designed to capture all relevant entities, properties, relationships, and lifecycle states during security assessments.

## Features

- **Comprehensive Asset Types**: Network infrastructure, systems, services, cloud resources, identity/access
- **Relationship Management**: Track complex relationships between assets
- **Lifecycle States**: Manage asset discovery, validation, enumeration, testing, and exploitation states
- **Trigger Integration**: Property-based trigger detection for methodology execution
- **Query System**: Advanced querying and filtering of assets
- **Import/Export**: Support for multiple formats (JSON, CSV, GraphML, STIX)
- **Validation**: Built-in validation rules for asset properties

## Installation

```bash
cd python_spike
pip install -r requirements.txt
```

## Quick Start

```python
from pentest_asset_model import AssetRepository
from pentest_asset_model.models import NetworkSegment, Host, Service

# Create repository
repo = AssetRepository()

# Create network segment
network = NetworkSegment(
    id="corp_net_1",
    name="Corporate Network",
    cidr="192.168.1.0/24",
    security_zone="Internal"
)
repo.add_asset(network)

# Create host
host = Host(
    id="host_1",
    hostname="DC01",
    ip="192.168.1.10"
)
repo.add_asset(host)

# Add relationship
network.add_relationship("CONTAINS", host.id)

# Query assets
hosts = repo.find_assets(asset_type="host", os_type="windows")
```

## Directory Structure

```
pentest_asset_model/
├── models/              # Asset model classes
│   ├── base.py         # Base asset classes
│   ├── network.py      # Network infrastructure assets
│   ├── systems.py      # Host and system assets
│   ├── services.py     # Service and application assets
│   ├── identity.py     # Identity and access assets
│   └── cloud.py        # Cloud resource assets
├── services/           # Business logic services
│   ├── repository.py   # Asset repository
│   ├── query.py        # Query engine
│   ├── triggers.py     # Trigger detection
│   └── validators.py   # Validation rules
├── utils/              # Utility functions
│   ├── import_export.py
│   └── risk_scoring.py
└── examples/           # Usage examples
```

## Documentation

See [PENTEST_ASSET_MODEL_SPEC.md](/PENTEST_ASSET_MODEL_SPEC.md) for complete specification.
