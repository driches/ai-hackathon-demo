.PHONY: setup activate mcp-server fetch-data run run-no-mcp mcp-start mcp-http mcp-dev mcp-test mcp-stop mcp-status docker-build docker-interactive clean help debug debug-embeddings debug-env debug-vectordb debug-graph debug-ingest ingest test-retrieval test-components debug-verbose clean-vectordb clean-all

# Default target
help:
	@echo "Available targets:"
	@echo "  make setup           - Set up the project (run setup.sh)"
	@echo "  make fetch-data      - Download NASA documents (required before ingest)"
	@echo "  make ingest          - Process PDF documents into vector database"
	@echo "  make run             - Run the main application"
	@echo "  make run-no-mcp      - Run without MCP (avoids connection errors)"
	@echo "  make clean           - Clean up temporary files and directories"
	@echo "  make clean-vectordb  - Remove vector database"
	@echo "  make clean-all       - Full cleanup including vector database"
	@echo ""
	@echo "MCP targets:"
	@echo "  make mcp-start       - Start MCP filesystem server (stdio transport)"
	@echo "  make mcp-http        - Start MCP server with HTTP transport (URL: http://127.0.0.1:8000)"
	@echo "  make mcp-dev         - Start MCP server with inspector (HTTP: 6274, Proxy: 6277)"
	@echo "  make mcp-test        - Test MCP integration with LangChain"
	@echo "  make mcp-stop        - Stop all running MCP processes"
	@echo "  make mcp-status      - Check MCP server status and ports"
	@echo ""
	@echo "Docker targets:"
	@echo "  make docker-build    - Build Docker image (includes NASA docs and vector DB)"
	@echo "  make docker-interactive - Run Docker container (interactive Q&A)"
	@echo ""
	@echo "Debug targets:"
	@echo "  make debug           - Run all debugging tests"
	@echo "  make debug-embeddings - Test OpenAI embeddings pipeline"
	@echo "  make debug-env       - Check environment variables and setup"
	@echo "  make debug-vectordb  - Inspect vector database contents"
	@echo "  make debug-graph     - Show graph structure and flow"
	@echo "  make debug-ingest    - Test PDF ingestion process"
	@echo "  make test-retrieval  - Test retrieval with sample queries"
	@echo "  make test-components - Test individual components (LLM, embeddings)"
	@echo "  make debug-verbose   - Run verbose debugging with all tests"

# Setup the project
setup:
	@echo "Setting up the project..."
	chmod +x setup.sh
	./setup.sh

# Download NASA documents from official sources
fetch-data:
	@echo "📥 Downloading NASA documents..."
	@if [ ! -f ".venv/bin/activate" ]; then \
		echo "❌ Virtual environment not found. Run 'make setup' first."; \
		exit 1; \
	fi
	source .venv/bin/activate && python fetch_nasa_data.py
	@echo "✅ NASA documents downloaded successfully to ./data/"

# Process PDF documents into vector database
ingest:
	@echo "📄 Processing PDF documents into vector database..."
	@if [ -d "./data" ] && [ $$(ls -1 ./data/*.pdf 2>/dev/null | wc -l) -gt 0 ]; then \
		source .venv/bin/activate && python ingest.py && echo "✅ Document ingestion completed successfully"; \
	else \
		echo "❌ No PDF files found in ./data directory"; \
		echo "💡 Run 'make fetch-data' first to download NASA documents"; \
		exit 1; \
	fi

# Run the application
run:
	@echo "Running the application..."
	source .venv/bin/activate && python main.py

# Run the application without MCP to avoid connection errors
run-no-mcp:
	@echo "Running the application without MCP..."
	source .venv/bin/activate && MCP_SERVER_URLS="" python main.py



# === MCP TARGETS ===

# Start MCP filesystem server (stdio transport for LangChain integration)
mcp-start:
	@echo "🔧 Starting MCP filesystem server..."
	@echo "📡 Transport: stdio (for LangChain integration)"
	@echo "🛑 Press Ctrl+C to stop"
	source .venv/bin/activate && fastmcp run mcp_filesystem.py

# Start MCP server with HTTP transport (for URL-based access)
mcp-http:
	@echo "🔧 Starting MCP filesystem server with HTTP transport..."
	@echo "📡 URL: http://127.0.0.1:8000"
	@echo "🌐 Use MCP_SERVER_URLS=http://127.0.0.1:8000"
	@echo "🛑 Press Ctrl+C to stop"
	source .venv/bin/activate && FASTMCP_TRANSPORT=http python mcp_filesystem.py

# Start MCP server with development inspector (HTTP transport)
mcp-dev:
	@echo "🔧 Starting MCP filesystem server with inspector..."
	@echo "📡 Inspector: http://127.0.0.1:6274"
	@echo "📡 Proxy: http://127.0.0.1:6277"
	@echo "🛑 Press Ctrl+C to stop"
	source .venv/bin/activate && fastmcp dev mcp_filesystem.py

# Test MCP integration with LangChain
mcp-test:
	@echo "🧪 Testing MCP integration with LangChain..."
	source .venv/bin/activate && python test_langchain_mcp.py

# Stop all running MCP processes
mcp-stop:
	@echo "🛑 Stopping all MCP processes..."
	@pkill -f "fastmcp|uvicorn.*mcp_filesystem" || echo "No MCP-related processes running"
	lsof -ti:8000 | xargs kill -9 2>/dev/null || echo "✅ Port 8000 is now free"
	@echo "✅ MCP processes stopped"

# Check MCP server status and ports
mcp-status:
	@echo "📊 Checking MCP server status..."
	@echo "🔍 Running MCP processes:"
	@ps aux | grep -E "(fastmcp|mcp)" | grep -v grep || echo "No MCP processes running"
	@echo ""
	@echo "🔍 MCP ports in use:"
	@netstat -an | grep LISTEN | grep -E "627[0-9]" || echo "No MCP ports in use"

# === DOCKER TARGETS ===

# Build Docker image (includes downloading docs and creating vector database)
docker-build:
	@echo "🐳 Building Docker image with NASA documents and vector database..."
	@echo "📥 This will download NASA PDFs and create the vector database during build..."
	@echo "⏱️  Build may take a few minutes due to document processing..."
	docker-compose build
	@echo "✅ Docker image built successfully - ready for interactive Q&A!"

# Run Docker container (interactive Q&A mode)
docker-interactive:
	@echo "🐳 Starting interactive NASA Q&A system..."
	@echo "🎯 Starting interactive Q&A session..."
	@echo "📝 Type 'quit', 'exit', or 'q' to stop"
	@echo ""
	docker-compose run --rm demo

# === DEBUG TARGETS ===

# Run comprehensive debugging suite
debug: debug-env debug-embeddings debug-vectordb debug-graph
	@echo "🎉 All debugging tests completed!"

# Test OpenAI embeddings pipeline
debug-embeddings:
	@echo "🧪 Testing embeddings pipeline..."
	source .venv/bin/activate && python debug_embeddings.py

# Check environment variables and setup
debug-env:
	@echo "🔍 Checking environment setup..."
	@echo "Python version:"
	@which python3
	@python3 --version
	@echo ""
	@echo "Virtual environment:"
	@echo "VIRTUAL_ENV: $$VIRTUAL_ENV"
	@echo ""
	@echo "Environment variables:"
	@source .venv/bin/activate && python -c "from dotenv import load_dotenv; import os; load_dotenv(override=True); print(f'OPENAI_API_KEY: {\"✅ Set\" if os.getenv(\"OPENAI_API_KEY\", \"\").startswith(\"sk-\") else \"❌ Missing or invalid\"}'); print(f'MCP_SERVER_URLS: {repr(os.getenv(\"MCP_SERVER_URLS\", \"\"))}')"

# Inspect vector database contents
debug-vectordb:
	@echo "📊 Inspecting vector database..."
	@if [ -d "./chroma_db" ]; then \
		echo "Vector database exists:"; \
		ls -la chroma_db/; \
		echo ""; \
		source .venv/bin/activate && python -c "from langchain_chroma import Chroma; from langchain_openai import OpenAIEmbeddings; from dotenv import load_dotenv; load_dotenv(override=True); vectordb = Chroma(persist_directory='./chroma_db', embedding_function=OpenAIEmbeddings(model='text-embedding-3-small')); collection = vectordb._collection; print(f'📈 Documents: {collection.count()}'); print(f'📝 Collection: {collection.name}')"; \
	else \
		echo "❌ Vector database not found. Run 'make debug-ingest' first."; \
	fi

# Show graph structure and execution flow
debug-graph:
	@echo "🔗 Analyzing graph structure..."
	source .venv/bin/activate && python -c "from main import chain; print('Graph nodes and edges:'); chain.get_graph().print_ascii()"

# Test PDF ingestion process
debug-ingest:
	@echo "📄 Testing PDF ingestion..."
	@if [ -d "./data" ] && [ $$(ls -1 ./data/*.pdf 2>/dev/null | wc -l) -gt 0 ]; then \
		echo "PDF files found:"; \
		ls -la data/*.pdf; \
		echo ""; \
		echo "Running ingestion..."; \
		source .venv/bin/activate && python ingest.py; \
		echo "✅ Ingestion completed"; \
	else \
		echo "❌ No PDF files found in ./data directory"; \
		echo "💡 Run 'make fetch-data' first to download NASA documents"; \
	fi

# Test retrieval with sample queries
test-retrieval:
	@echo "🔍 Testing retrieval with sample queries..."
	@if [ -d "./chroma_db" ]; then \
		source .venv/bin/activate && python test_retrieval.py; \
	else \
		echo "❌ Vector database not found. Run 'make debug-ingest' first."; \
	fi

# Test individual components
test-components:
	@echo "🧩 Testing individual components..."
	@echo "1. Testing OpenAI connection..."
	@source .venv/bin/activate && python -c "from langchain_openai import ChatOpenAI; from dotenv import load_dotenv; load_dotenv(override=True); llm = ChatOpenAI(model='gpt-5-mini', reasoning_effort='medium'); response = llm.invoke('Hello, respond with just OK'); print(f'✅ LLM Response: {response.content}')"
	@echo ""
	@echo "2. Testing embeddings..."
	@source .venv/bin/activate && python -c "from langchain_openai import OpenAIEmbeddings; from dotenv import load_dotenv; load_dotenv(override=True); embedder = OpenAIEmbeddings(model='text-embedding-3-small'); embedding = embedder.embed_query('test'); print(f'✅ Embedding dimensions: {len(embedding)}')"

# Debug with verbose output
debug-verbose: 
	@echo "🔊 Running verbose debugging..."
	@echo "=== ENVIRONMENT ==="
	@make debug-env
	@echo ""
	@echo "=== VECTOR DATABASE ==="
	@make debug-vectordb
	@echo ""
	@echo "=== COMPONENTS ==="
	@make test-components
	@echo ""
	@echo "=== EMBEDDINGS PIPELINE ==="
	@make debug-embeddings

# Clean up temporary files and directories
clean:
	@echo "Cleaning up..."
	rm -rf __pycache__
	rm -rf .pytest_cache
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete

# Clean vector database (useful for testing re-ingestion)
clean-vectordb:
	@echo "🗑️  Cleaning vector database..."
	rm -rf chroma_db/
	@echo "✅ Vector database removed. Run 'make debug-ingest' to recreate."

# Full clean including vector database and data
clean-all: clean clean-vectordb
	@echo "🗑️  Removing downloaded data..."
	rm -rf data/
	@echo "🧹 Full cleanup completed" 