# Methodology Engine Spike 🎯

A Python prototype demonstrating **asset-property-driven trigger systems** with **intelligent batch command generation** for penetration testing workflows.

> **Built with joy** for exploring innovative methodology execution patterns before porting to Dart/Flutter! 🚀

## Features

- **Asset-Property Triggers**: Methodologies trigger based on asset properties, not arbitrary completion events
- **Intelligent Deduplication**: Prevents redundant executions with signature-based tracking
- **Batch Command Generation**: Automatically combines similar triggers into efficient batch commands
- **Realistic Attack Progression**: Network discoveries naturally trigger appropriate methodologies
- **Real-time Web UI**: Interactive dashboard showing assets, triggers, and generated commands
- **Enhanced Assets Manager**: Dedicated screen for managing assets with type-specific property editors
- **Full CRUD Operations**: Create, read, update, and delete assets via REST API and beautiful web UI

## What Makes This Special? ✨

### 1. Property-Based Triggers (Not Completion-Based)

**Traditional**: "Run nmap, then run nikto, then run..."
**This System**: "When I see a web service on port 80, enumerate it"

This is **fundamentally different** and much more realistic!

### 2. Intelligent Batch Generation

The system automatically detects when multiple similar operations can be batched:

```bash
# Instead of 4 individual commands:
nikto -h http://10.10.10.5:80
nikto -h http://10.10.10.5:443
nikto -h http://10.10.10.7:8080
nikto -h http://10.10.10.12:443

# Generates 1 efficient batch:
parallel -j 4 'nikto -h {} -output nikto_{#}.txt' ::: \
  http://10.10.10.5:80 \
  http://10.10.10.5:443 \
  http://10.10.10.7:8080 \
  http://10.10.10.12:443
```

**Result**: 4-10x performance improvement! ⚡

### 3. Smart Deduplication

Prevents running the same methodology multiple times on identical asset combinations:

```python
signature = hash(methodology_id + asset_properties)
if already_executed(signature): skip
```

This avoids wasted effort and duplicate findings.

## Quick Start

```bash
# Navigate to project
cd /home/user/methodology-engine-spike

# Install dependencies
pip install -r requirements.txt

# Run the web server
python run.py

# Open browser to http://localhost:8000
```

**📚 Documentation:**
- [QUICKSTART.md](QUICKSTART.md) - Installation and basic usage
- [DEMO.md](DEMO.md) - Detailed demo walkthrough and concepts
- [ARCHITECTURE.md](ARCHITECTURE.md) - Technical architecture deep dive

## Demo Scenarios

1. **Network Discovery**: Add a subnet → triggers nmap → discovers hosts → triggers service enumeration
2. **NAC Bypass**: Add network_segment with NAC → triggers credential testing → batch command generation
3. **Web Services**: Discover multiple web services → batches into parallel eyewitness/nikto commands

## Technology Stack

- **Backend**: FastAPI (Python 3.x)
- **Frontend**: Vanilla HTML/CSS/JavaScript (no framework bloat!)
- **Data Format**: YAML for methodologies (human-readable)
- **Architecture**: Event-driven with in-memory storage

## Project Status

This is a **spike/prototype** to validate concepts before implementing in Dart/Flutter.

**✅ Implemented:**
- Asset model with property matching
- Trigger evaluation system
- Deduplication logic
- Batch command generation
- Web UI with real-time updates
- 5 realistic YAML methodologies
- Demo scenarios

**🔮 Future (Dart Port):**
- Actual command execution
- Output parsing for asset discovery
- Persistent storage (SQLite/Drift)
- Mobile-responsive UI
- Advanced trigger types
- Collaboration features

## Web UI Screens

### Main Dashboard (`/`)
- Real-time statistics (assets, methodologies, triggers, commands)
- Generated batch commands display
- Trigger matches visualization
- Demo scenarios for quick testing
- Quick asset creation form

### Assets Manager (`/static/assets.html`) ⭐ NEW!
- **Grid-based asset display** with color-coded cards by type
- **Advanced filtering**: Search by name and filter by asset type
- **Type-specific property editors**: Each asset type has custom property fields
- **Full CRUD operations**: Create, edit, view, and delete assets
- **Smart property templates**: Pre-configured fields for:
  - Network Segments (CIDR, VLAN, NAC config, access levels)
  - Hosts (IP, hostname, MAC, OS, open ports)
  - Services (host, port, protocol, version, URL)
  - Credentials (username, password, type, domain, validity)
  - Web Applications (URL, technology, version, authentication)
- **Instant validation**: Type-specific validation for all property fields
- **Beautiful UI**: Modern dark theme with smooth animations

## File Structure

```
methodology-engine-spike/
├── 📂 engine/                 # Core engine logic
│   ├── models.py              # Data models (Asset, Methodology, Trigger, etc.)
│   ├── trigger_matcher.py     # Trigger evaluation logic
│   ├── deduplicator.py        # Deduplication tracking
│   ├── batch_generator.py     # Batch command generation
│   └── methodology_engine.py  # Main orchestrator
├── 📂 methodologies/          # YAML methodology definitions
│   ├── recon/                 # Reconnaissance methodologies
│   ├── enumeration/           # Enumeration methodologies
│   └── exploitation/          # Exploitation methodologies (NAC bypass!)
├── 📂 web/                    # Web interface
│   ├── api.py                 # FastAPI server
│   └── static/                # HTML/CSS/JS frontend
├── 📄 run.py                  # Entry point
├── 📄 test_engine.py          # Basic test script
├── 📄 README.md               # This file
├── 📄 QUICKSTART.md           # Quick installation guide
├── 📄 DEMO.md                 # Detailed demo walkthrough
└── 📄 ARCHITECTURE.md         # Technical deep dive
```

## Philosophy

Unlike traditional linear methodology execution, this engine uses **asset properties to drive attack progression**:

- When you discover a web service on port 80, web enumeration methodologies automatically trigger
- When NAC is detected with credentials, bypass methodologies trigger with batched attempts
- Deduplication prevents running the same methodology multiple times on identical asset combinations

This creates a realistic, intelligent attack flow that mimics how real penetration testers work.

## Example YAML Methodology

```yaml
id: web_service_enumeration
name: Web Service Enumeration
category: enumeration
risk_level: low
batch_compatible: true

triggers:
  - id: trigger_web_service_discovered
    type: asset_discovered
    asset_type: service
    required_properties:
      port: { "$in": [80, 443, 8080, 8443] }
      protocol: http
    deduplication:
      enabled: true
      strategy: signature_based
      signature_fields: ["host", "port"]

steps:
  - name: EyeWitness Screenshots
    command: "eyewitness --web -f {targets_file} --no-prompt"
  - name: Nikto Scan
    command: "parallel -j 4 'nikto -h {}' ::: {targets}"
```

## Contributing

This is a spike project for exploration. If you have ideas for the Dart/Flutter port, feel free to experiment!

## License

MIT License - Feel free to use and modify!

---

**Built by Claude** with enthusiasm for innovative pentesting automation! 🎯✨
