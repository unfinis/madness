## Quick Start

### Installation

```bash
cd /home/user/methodology-engine-spike

# Install dependencies
pip install -r requirements.txt
```

### Run the Server

```bash
python run.py
```

Open your browser to: **http://localhost:8000**

### Try Demo Scenarios

The web UI has three pre-built scenarios that demonstrate the engine:

1. **Network Discovery** - Shows how discovering a subnet triggers nmap methodologies
2. **NAC Bypass** - Demonstrates credential batching (the killer feature!)
3. **Web Enumeration** - Shows batch command generation for multiple web services

Click the buttons in the "Demo Scenarios" section to run them!

### Add Custom Assets

1. Click "➕ Add Asset"
2. Select the asset type
3. Fill in the name
4. Add properties as JSON (templates are provided)
5. Click "Create Asset"
6. Watch triggers fire and commands generate!

### Example: Trigger Web Enumeration

**Add a web service**:
```json
Type: service
Name: Corporate Web Server
Properties: {
  "host": "10.10.10.100",
  "port": 80,
  "protocol": "http",
  "url": "http://10.10.10.100"
}
```

This automatically triggers:
- EyeWitness screenshots
- Nikto vulnerability scan
- Gobuster directory enumeration

### Reset and Try Again

Click "🗑️ Reset Engine" to clear all data and start fresh.

### API Documentation

FastAPI automatically generates API docs at: **http://localhost:8000/docs**

### Project Structure

```
methodology-engine-spike/
├── engine/              # Core engine (trigger matching, batching, deduplication)
├── methodologies/       # YAML methodology definitions
├── web/                 # FastAPI server and web UI
├── run.py              # Entry point
└── test_engine.py      # Simple test script
```

### Next Steps

1. Read DEMO.md for detailed explanation of concepts
2. Explore the YAML methodologies in `methodologies/`
3. Try creating your own methodology!
4. Check out the code in `engine/` to understand how it works

### Troubleshooting

**Port 8000 already in use?**
```bash
# Edit run.py and change port to 8001 or another port
```

**Dependencies not installing?**
```bash
# Create a virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Web UI not loading?**
- Make sure you're accessing http://localhost:8000 (not https)
- Check that `web/static/index.html` exists
- Look at server logs for errors
