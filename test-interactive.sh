#!/bin/bash

# Interactive test for SwiftOpenAI MCP Server
# This keeps the server running and lets you send messages

echo "Starting SwiftOpenAI MCP Server in interactive mode..."
echo "The server is waiting for JSON-RPC messages on stdin."
echo "Type your messages and press Enter. Press Ctrl+D to exit."
echo ""
echo "Example messages to try:"
echo ""
echo '1. Initialize:'
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'
echo ""
echo '2. List tools:'
echo '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'
echo ""
echo '3. List models:'
echo '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"list_models","arguments":{}}}'
echo ""
echo "========================================="
echo ""

# Set API key if not already set
export OPENAI_API_KEY="${OPENAI_API_KEY:-test-key}"

# Run the server
./.build/debug/swiftopenai-mcp