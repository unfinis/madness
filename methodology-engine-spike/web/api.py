"""FastAPI web server for methodology engine."""
from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse, FileResponse
from pydantic import BaseModel
from typing import List, Dict, Any, Optional
from pathlib import Path
import uuid
from datetime import datetime

from engine import MethodologyEngine, Asset, AssetType

# Initialize FastAPI app
app = FastAPI(
    title="Methodology Engine Spike",
    description="Asset-driven trigger system with intelligent batch command generation",
    version="1.0.0"
)

# Initialize engine
engine = MethodologyEngine()

# Load methodologies on startup
methodologies_dir = Path(__file__).parent.parent / "methodologies"
if methodologies_dir.exists():
    engine.load_methodologies_from_yaml(methodologies_dir)


# Request/Response Models
class AssetCreate(BaseModel):
    type: str
    name: str
    properties: Dict[str, Any] = {}
    confidence: float = 1.0


class AssetResponse(BaseModel):
    id: str
    type: str
    name: str
    properties: Dict[str, Any]
    confidence: float
    discovered_at: str


class TriggerMatchResponse(BaseModel):
    trigger_id: str
    methodology_id: str
    methodology_name: str
    priority: int
    confidence: float
    matched_assets: List[AssetResponse]
    matched_at: str
    executed: bool


class BatchCommandResponse(BaseModel):
    id: str
    methodology_id: str
    methodology_name: str
    command: str
    target_count: int
    created_at: str
    batched: bool


class StatsResponse(BaseModel):
    total_assets: int
    total_methodologies: int
    total_trigger_matches: int
    total_batch_commands: int
    pending_commands: int
    assets_by_type: Dict[str, int]


# API Endpoints

@app.get("/")
async def root():
    """Serve the web UI."""
    html_file = Path(__file__).parent / "static" / "index.html"
    if html_file.exists():
        return FileResponse(html_file)
    return HTMLResponse("<h1>Methodology Engine Spike</h1><p>UI not found. Please check static/index.html</p>")


@app.get("/api/assets", response_model=List[AssetResponse])
async def get_assets():
    """Get all assets."""
    return [
        AssetResponse(
            id=asset.id,
            type=asset.type.value,
            name=asset.name,
            properties=asset.properties,
            confidence=asset.confidence,
            discovered_at=asset.discovered_at.isoformat()
        )
        for asset in engine.get_assets()
    ]


@app.get("/api/assets/{asset_id}", response_model=AssetResponse)
async def get_asset(asset_id: str):
    """Get a specific asset by ID."""
    assets = engine.get_assets()
    asset = next((a for a in assets if a.id == asset_id), None)
    if not asset:
        raise HTTPException(status_code=404, detail=f"Asset {asset_id} not found")

    return AssetResponse(
        id=asset.id,
        type=asset.type.value,
        name=asset.name,
        properties=asset.properties,
        confidence=asset.confidence,
        discovered_at=asset.discovered_at.isoformat()
    )


@app.post("/api/assets", response_model=Dict[str, Any])
async def create_asset(asset_data: AssetCreate):
    """Create a new asset and trigger evaluation."""
    try:
        # Create asset
        asset = Asset(
            id=str(uuid.uuid4()),
            type=AssetType[asset_data.type.upper()],
            name=asset_data.name,
            properties=asset_data.properties,
            confidence=asset_data.confidence
        )

        # Add to engine (triggers evaluation)
        new_matches = engine.add_asset(asset)

        # Get newly generated commands
        all_commands = engine.get_pending_commands()
        new_commands = [
            cmd for cmd in all_commands
            if any(match.signature == m.signature for m in new_matches for match in cmd.trigger_matches)
        ]

        return {
            "asset": AssetResponse(
                id=asset.id,
                type=asset.type.value,
                name=asset.name,
                properties=asset.properties,
                confidence=asset.confidence,
                discovered_at=asset.discovered_at.isoformat()
            ),
            "triggered_matches": len(new_matches),
            "generated_commands": len(new_commands),
            "matches": [
                {
                    "methodology_id": match.methodology_id,
                    "priority": match.priority,
                    "confidence": match.confidence
                }
                for match in new_matches
            ]
        }
    except KeyError as e:
        raise HTTPException(status_code=400, detail=f"Invalid asset type: {asset_data.type}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.put("/api/assets/{asset_id}", response_model=AssetResponse)
async def update_asset(asset_id: str, asset_data: AssetCreate):
    """Update an existing asset."""
    try:
        # Find existing asset
        assets = engine.get_assets()
        existing_asset = next((a for a in assets if a.id == asset_id), None)
        if not existing_asset:
            raise HTTPException(status_code=404, detail=f"Asset {asset_id} not found")

        # Update asset properties
        updated_asset = Asset(
            id=asset_id,
            type=AssetType[asset_data.type.upper()],
            name=asset_data.name,
            properties=asset_data.properties,
            confidence=asset_data.confidence,
            discovered_at=existing_asset.discovered_at
        )

        # Remove old asset and add updated one
        engine.assets = [a for a in engine.assets if a.id != asset_id]
        engine.add_asset(updated_asset)

        return AssetResponse(
            id=updated_asset.id,
            type=updated_asset.type.value,
            name=updated_asset.name,
            properties=updated_asset.properties,
            confidence=updated_asset.confidence,
            discovered_at=updated_asset.discovered_at.isoformat()
        )
    except KeyError as e:
        raise HTTPException(status_code=400, detail=f"Invalid asset type: {asset_data.type}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.delete("/api/assets/{asset_id}")
async def delete_asset(asset_id: str):
    """Delete an asset."""
    assets = engine.get_assets()
    asset = next((a for a in assets if a.id == asset_id), None)
    if not asset:
        raise HTTPException(status_code=404, detail=f"Asset {asset_id} not found")

    engine.assets = [a for a in engine.assets if a.id != asset_id]
    return {"message": f"Asset {asset_id} deleted successfully"}


@app.get("/api/methodologies")
async def get_methodologies():
    """Get all loaded methodologies."""
    methodologies = engine.get_methodologies()
    return [
        {
            "id": m.id,
            "name": m.name,
            "description": m.description,
            "category": m.category,
            "risk_level": m.risk_level,
            "trigger_count": len(m.triggers),
            "step_count": len(m.steps),
            "batch_compatible": m.batch_compatible
        }
        for m in methodologies
    ]


@app.get("/api/methodologies/{methodology_id}")
async def get_methodology_detail(methodology_id: str):
    """Get detailed information about a specific methodology."""
    methodologies = engine.get_methodologies()
    methodology = next((m for m in methodologies if m.id == methodology_id), None)

    if not methodology:
        raise HTTPException(status_code=404, detail=f"Methodology {methodology_id} not found")

    return {
        "id": methodology.id,
        "name": methodology.name,
        "description": methodology.description,
        "category": methodology.category,
        "risk_level": methodology.risk_level,
        "batch_compatible": methodology.batch_compatible,
        "triggers": [
            {
                "id": t.id,
                "type": t.type,
                "description": t.description,
                "priority": t.priority,
                "asset_type": getattr(t, 'asset_type', None),
                "required_properties": getattr(t, 'required_properties', {}),
                "required_count": getattr(t, 'required_count', 1),
                "deduplication": {
                    "enabled": t.deduplication.enabled if t.deduplication else False,
                    "strategy": t.deduplication.strategy if t.deduplication else None,
                    "signature_fields": t.deduplication.signature_fields if t.deduplication else [],
                    "cooldown_seconds": t.deduplication.cooldown_seconds if t.deduplication else None,
                }
            }
            for t in methodology.triggers
        ],
        "steps": [
            {
                "id": s.id,
                "name": s.name,
                "description": s.description,
                "command": s.command,
                "order": s.order,
                "timeout_seconds": s.timeout_seconds,
                "requires_confirmation": getattr(s, 'requires_confirmation', False)
            }
            for s in methodology.steps
        ],
        "metadata": {
            "tools": methodology.metadata.get("tools", []) if methodology.metadata else [],
            "risk_warning": methodology.metadata.get("risk_warning", "") if methodology.metadata else "",
            "batch_strategy": methodology.metadata.get("batch_strategy", "") if methodology.metadata else "",
            "expected_outcomes": methodology.metadata.get("expected_outcomes", []) if methodology.metadata else [],
            "common_issues": methodology.metadata.get("common_issues", []) if methodology.metadata else [],
            "troubleshooting": methodology.metadata.get("troubleshooting", {}) if methodology.metadata else {}
        }
    }


@app.get("/api/trigger-matches", response_model=List[TriggerMatchResponse])
async def get_trigger_matches():
    """Get all trigger matches."""
    matches = engine.get_trigger_matches()
    methodologies = {m.id: m for m in engine.get_methodologies()}

    return [
        TriggerMatchResponse(
            trigger_id=match.trigger_id,
            methodology_id=match.methodology_id,
            methodology_name=methodologies.get(match.methodology_id, type('obj', (), {'name': 'Unknown'})).name,
            priority=match.priority,
            confidence=match.confidence,
            matched_assets=[
                AssetResponse(
                    id=asset.id,
                    type=asset.type.value,
                    name=asset.name,
                    properties=asset.properties,
                    confidence=asset.confidence,
                    discovered_at=asset.discovered_at.isoformat()
                )
                for asset in match.matched_assets
            ],
            matched_at=match.matched_at.isoformat(),
            executed=match.executed
        )
        for match in matches
    ]


@app.get("/api/batch-commands", response_model=List[BatchCommandResponse])
async def get_batch_commands():
    """Get all generated batch commands."""
    commands = engine.get_pending_commands()
    methodologies = {m.id: m for m in engine.get_methodologies()}

    return [
        BatchCommandResponse(
            id=cmd.id,
            methodology_id=cmd.methodology_id,
            methodology_name=methodologies.get(cmd.methodology_id, type('obj', (), {'name': 'Unknown'})).name,
            command=cmd.command,
            target_count=cmd.target_count,
            created_at=cmd.created_at.isoformat(),
            batched=cmd.metadata.get("batched", False)
        )
        for cmd in commands
    ]


@app.get("/api/stats", response_model=StatsResponse)
async def get_stats():
    """Get engine statistics."""
    stats = engine.get_stats()
    return StatsResponse(**stats)


@app.post("/api/reset")
async def reset_engine():
    """Reset the engine state."""
    engine.clear()
    return {"message": "Engine reset successfully"}


@app.post("/api/demo/scenario/{scenario_name}")
async def run_demo_scenario(scenario_name: str):
    """Run a predefined demo scenario."""
    if scenario_name == "network_discovery":
        return await demo_network_discovery()
    elif scenario_name == "nac_bypass":
        return await demo_nac_bypass()
    elif scenario_name == "web_enumeration":
        return await demo_web_enumeration()
    else:
        raise HTTPException(status_code=404, detail=f"Scenario '{scenario_name}' not found")


async def demo_network_discovery():
    """Demo: Network discovery progression."""
    # Add a network segment
    subnet = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.NETWORK_SEGMENT,
        name="Corporate Network",
        properties={
            "cidr": "10.10.10.0/24",
            "vlan": "100",
            "description": "Main corporate network"
        }
    )
    engine.add_asset(subnet)

    # Simulate discovering hosts
    for i in range(1, 6):
        host = Asset(
            id=str(uuid.uuid4()),
            type=AssetType.HOST,
            name=f"host-10.10.10.{i}",
            properties={
                "ip": f"10.10.10.{i}",
                "hostname": f"WKS-{i:03d}",
                "os": "Windows 10" if i % 2 == 0 else "Ubuntu 20.04"
            }
        )
        engine.add_asset(host)

    return {"message": "Network discovery scenario completed", "stats": engine.get_stats()}


async def demo_nac_bypass():
    """Demo: NAC bypass with credentials."""
    # Add NAC-protected network
    nac_network = Asset(
        id=str(uuid.uuid4()),
        type=AssetType.NETWORK_SEGMENT,
        name="Guest WiFi with NAC",
        properties={
            "network_id": "guest_wifi_01",
            "nac_enabled": True,
            "access_level": "blocked",
            "ssid": "CorpGuest"
        }
    )
    engine.add_asset(nac_network)

    # Add multiple credentials (triggers batching!)
    credentials = [
        ("user1", "Password123!"),
        ("user2", "Summer2024"),
        ("admin", "AdminPass"),
        ("guest", "Guest123"),
    ]

    for username, password in credentials:
        cred = Asset(
            id=str(uuid.uuid4()),
            type=AssetType.CREDENTIAL,
            name=f"{username} credentials",
            properties={
                "username": username,
                "password": password,
                "type": "domain",
                "source": "credential_dump"
            }
        )
        engine.add_asset(cred)

    return {"message": "NAC bypass scenario completed", "stats": engine.get_stats()}


async def demo_web_enumeration():
    """Demo: Web service enumeration with batching."""
    # Discover multiple web services
    web_services = [
        ("10.10.10.5", 80, "http"),
        ("10.10.10.5", 443, "https"),
        ("10.10.10.7", 8080, "http"),
        ("10.10.10.12", 443, "https"),
    ]

    for ip, port, protocol in web_services:
        service = Asset(
            id=str(uuid.uuid4()),
            type=AssetType.SERVICE,
            name=f"{protocol.upper()} on {ip}:{port}",
            properties={
                "host": ip,
                "port": port,
                "protocol": "http",
                "url": f"{protocol}://{ip}:{port}",
                "service_name": "http"
            }
        )
        engine.add_asset(service)

    return {"message": "Web enumeration scenario completed", "stats": engine.get_stats()}


# Mount static files
static_dir = Path(__file__).parent / "static"
if static_dir.exists():
    app.mount("/static", StaticFiles(directory=str(static_dir)), name="static")
