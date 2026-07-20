---
type: Architecture
title: Repository Structure and 5-Layer Architecture
description: Flat Python project with a shared `common/` package, described by the README as a clean 5-layer modular architecture using the React agent pattern.
tags: [architecture, structure, react-agent, python]
timestamp: 2026-07-20T00:00:00Z
---

# Repository Structure and Architecture

The README describes a "clean 5-layer modular architecture with single responsibility components" built around LangChain's React agent pattern (intelligent reasoning and tool selection). See [overview](/overview.md).

## Layout (from digest structure)

Top-level scripts, one shared package:

- `main.py` — application entry point.
- `ingest.py` — document ingestion into the vector store.
- `fetch_nasa_data.py` — fetches NASA source data.
- `mcp_filesystem.py` — MCP filesystem integration (see [MCP integration](/mcp-integration.md)).
- `test_retrieval.py`, `test_langchain_mcp.py`, `debug_embeddings.py` — retrieval tests and debugging tools.
- `common/` — shared package with its own README:
  - `config.py` — configuration (README: environment-driven config with validation and graceful degradation).
  - `agent_factory.py` — agent construction.
  - `nasa_search.py` — NASA search functionality.
  - `mcp_client.py` — MCP client.
  - `thinking_spinner.py` — CLI spinner/UX helper.
- Deployment/tooling: `Dockerfile`, `docker-compose.yaml`, `Makefile`, `setup.sh`, `activate.sh`, `start.sh` (see [dev workflow](/dev-workflow.md)).

## Data flow (as evidenced)

PDF documents are ingested (`ingest.py`, using `unstructured[pdf]`/`pdfminer.six`), chunked and embedded into Chroma, then queried at runtime by a React agent that selects tools and retrieves relevant chunks to answer questions.

## Open questions

- What the five named layers are — the README's Architecture section body was not included in the digest.
- Exact responsibilities/interfaces of `agent_factory.py` and `nasa_search.py`.
- Whether `fastapi`/`uvicorn` (present in requirements) mean there is an HTTP API layer, and where it lives.
