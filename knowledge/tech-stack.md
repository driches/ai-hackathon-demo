---
type: Dependency
title: Tech Stack and Key Dependencies
description: Python 3.13 project on LangChain 0.3 with OpenAI GPT-4o-mini, Chroma vector DB, MCP adapters, PDF processing libraries, and FastAPI/uvicorn in requirements.
tags: [dependencies, langchain, openai, chroma, mcp, python]
timestamp: 2026-07-20T00:00:00Z
---

# Tech Stack and Key Dependencies

## Runtime

- **Python 3.13+** (README: tested with 3.13.1); `uv` appears in requirements.
- **Docker** deployment supported (`Dockerfile`, `docker-compose.yaml`).

## Core dependencies (from requirements.txt)

- `langchain==0.3.*`, `langgraph`, `langchain-community` — agent/retrieval framework; README cites the React agent pattern.
- `langchain-openai` — OpenAI GPT-4o-mini for generation and embeddings (README rationale: high-quality, cost-effective).
- `langchain-chroma`, `chromadb` — Chroma vector database for semantic search over document chunks.
- `langchain-mcp-adapters`, `mcp[cli]`, `fastmcp` — optional [MCP integration](/mcp-integration.md).
- `unstructured[pdf]`, `pdfminer.six`, `pi-heif` — PDF/document processing for ingestion.
- `python-dotenv` — `.env`-based configuration (see [dev workflow](/dev-workflow.md)).
- `requests` — HTTP client (plausibly used by `fetch_nasa_data.py`).
- `fastapi`, `uvicorn` — web serving dependencies.

## Configuration

An **OpenAI API key is required** (set in `.env`; `.env.example` is provided as a template). README highlights environment-driven configuration with validation and graceful degradation, implemented in `common/config.py`.

## Open questions

- Whether FastAPI/uvicorn are actively used (no obvious server module in the structure besides possibly `main.py` or `mcp_filesystem.py`) or are aspirational/leftover.
- Exact embedding model and chunking parameters used.
- What other environment variables `common/config.py` supports beyond the OpenAI key.
