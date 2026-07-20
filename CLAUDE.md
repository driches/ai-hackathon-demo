# ai-hackathon-demo

## Knowledge

This repo uses an agent-maintained OKF knowledge bundle at `knowledge/` instead of RAG. Answer questions from `knowledge/index.md` first; ingest new sources by synthesizing into concept pages (update index.md, append to log.md; raw sources are immutable); lint for contradictions, orphans, and broken links during substantial knowledge work. Do not introduce vector stores/embeddings without proposing why the bundle is insufficient. Full conventions: the `knowledge-bundle` skill / ~/Developer/CLAUDE.md.
