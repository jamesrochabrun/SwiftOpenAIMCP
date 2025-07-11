#!/bin/bash

# Simple test that sends one message at a time

echo "Testing MCP Server..."
echo ""

# Test 1: Send initialize and wait
echo "Sending initialize request..."
(echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'; sleep 1) | OPENAI_API_KEY=test ./.build/debug/swiftopenai-mcp 2>/dev/null

echo ""
echo "To test interactively, run:"
echo "./test-interactive.sh"
echo ""
echo "Then paste these messages one at a time:"
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'
echo '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'
echo '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"list_models","arguments":{}}}'