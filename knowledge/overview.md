---
type: Overview
title: NASA Document Q&A System
description: An intelligent question-answering system over NASA technical documents, built with LangChain and OpenAI, aimed at executive-level insights.
tags: [nasa, qa, rag, langchain, hackathon]
timestamp: 2026-07-20T00:00:00Z
---

# NASA Document Q&A System

The repo `ai-hackathon-demo` (github.com/driches/ai-hackathon-demo) is a question-answering system that transforms NASA's technical documentation into an interactive Q&A interface designed for executives and technical leaders. It is built with LangChain's React agent pattern and OpenAI's GPT-4o-mini, retrieving relevant information from processed NASA documents stored in a Chroma vector database.

## Problems it solves (per README)

- **Information overload**: extracts key insights quickly from extensive, complex NASA documents.
- **Executive decision making**: provides executive-level summaries and analysis.
- **Compliance tracking**: quick retrieval of governance and compliance information.
- **Knowledge discovery**: uncovers connections between different NASA documents and initiatives.

## Key characteristics

- Semantic (vector) search over PDF-derived document chunks; README claims sub-second query processing with 361 indexed documents.
- Optional [MCP integration](/mcp-integration.md) for filesystem and external tool access.
- Clean 5-layer modular [architecture](/architecture.md); see also the [tech stack](/tech-stack.md) and [developer workflow](/dev-workflow.md).
- Runs either locally with Python 3.13+ or via Docker.

## Open questions

- What the CLI/interaction loop in `main.py` looks like (entry-point behavior not in digest).
- Which specific NASA documents are ingested and where `fetch_nasa_data.py` sources them from.
- What "Analytics Ready" metrics/performance monitoring actually consists of.
