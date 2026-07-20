---
type: Service
title: Optional MCP Integration
description: Optional Model Context Protocol support giving the agent filesystem and external tool access, wired through langchain-mcp-adapters.
tags: [mcp, filesystem, tools, integration]
timestamp: 2026-07-20T00:00:00Z
---

# Optional MCP Integration

The system features **optional** MCP (Model Context Protocol) integration for enhanced filesystem capabilities and external tool access — the README repeatedly frames it as optional, implying the Q&A system works without it (graceful degradation is a stated config principle).

## Evidence in the repo

- `mcp_filesystem.py` at the repo root — MCP filesystem server/integration.
- `common/mcp_client.py` — MCP client used by the shared package.
- `test_langchain_mcp.py` — tests the LangChain-MCP bridge.
- Dependencies: `langchain-mcp-adapters`, `mcp[cli]`, `fastmcp` (see [tech stack](/tech-stack.md)).

MCP tools presumably surface to the React agent alongside retrieval tools (see [architecture](/architecture.md)).

## Open questions

- Whether `mcp_filesystem.py` is a FastMCP server (which could explain the `fastmcp`/`fastapi`/`uvicorn` dependencies) or a client-side wrapper.
- How MCP is enabled/disabled (env flag? CLI option?).
- Which concrete MCP tools the agent is given.
