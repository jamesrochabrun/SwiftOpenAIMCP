#!/bin/bash

# Test script for SwiftOpenAI MCP Server

export OPENAI_API_KEY="test-key"

# Test initialize request
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | ./.build/debug/swiftopenai-mcp