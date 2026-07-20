---
type: Convention
title: Setup, Deployment, and Debugging Workflow
description: Script-driven setup (setup.sh, activate.sh, start.sh, Makefile), .env-based configuration, Docker deployment, and dedicated debugging utilities.
tags: [workflow, setup, docker, debugging, convention]
timestamp: 2026-07-20T00:00:00Z
---

# Setup, Deployment, and Debugging Workflow

## Two supported run modes

1. **Local Python** — full development capabilities with debugging tools. Quick start (from README): clone the repo, run `./setup.sh`, then edit `.env` to set your OpenAI API key (replacing the `your_openai_api_key_here` placeholder).
2. **Docker** — isolated, consistent deployment via `Dockerfile` and `docker-compose.yaml`; README notes "containerized deployment with interactive support". `.dockerignore` is present.

## Script/tooling conventions

- `setup.sh` — automated environment setup.
- `activate.sh` — development environment activation.
- `start.sh` — application start.
- `Makefile` — task automation (targets not shown in digest).
- Configuration lives in `.env` (template: `.env.example`), loaded via `python-dotenv` and validated by `common/config.py` (see [tech stack](/tech-stack.md)).

## Debugging and testing

The README advertises "comprehensive debugging" and system health monitoring, backed by dedicated top-level scripts:

- `debug_embeddings.py` — inspect embeddings/vector store health.
- `test_retrieval.py` — verify retrieval quality.
- `test_langchain_mcp.py` — verify [MCP integration](/mcp-integration.md).

These are standalone scripts rather than a pytest-style test suite (no `tests/` directory in the structure).

## Open questions

- Makefile targets and what `start.sh` does relative to `main.py`.
- CI setup, if any (none visible in the digest).
- The README's "Activation for Development" and later sections were truncated in the digest; a full README ingest should fill in usage examples and the Architecture section.
