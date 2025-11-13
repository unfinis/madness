#!/usr/bin/env python3
"""Entry point for the Methodology Engine Spike."""
import uvicorn
from pathlib import Path

if __name__ == "__main__":
    print("""
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║         🎯  METHODOLOGY ENGINE SPIKE  🎯                     ║
    ║                                                              ║
    ║  Asset-Property-Driven Trigger System with                   ║
    ║  Intelligent Batch Command Generation                        ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝

    Starting web server...

    🌐 Web UI: http://localhost:8000
    📚 API Docs: http://localhost:8000/docs

    Press Ctrl+C to stop
    """)

    uvicorn.run(
        "web.api:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
