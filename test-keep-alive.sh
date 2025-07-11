#!/bin/bash

echo "Starting MCP Server (it will stay running)..."
echo "Paste JSON messages below and press Enter after each one:"
echo ""
echo "Example: "
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'
echo ""
echo "==========================================="

# Use cat to keep stdin open
export OPENAI_API_KEY="${OPENAI_API_KEY:-test-key}"
cat | ./.build/debug/swiftopenai-mcp