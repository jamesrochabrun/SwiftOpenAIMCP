#!/bin/bash

echo "Testing server with Claude's protocol version..."

# Test with the exact message Claude sends
cat << 'EOF' | OPENAI_API_KEY="${OPENAI_API_KEY:-test}" ./.build/debug/swiftopenai-mcp
{"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"claude-ai","version":"0.1.0"}},"jsonrpc":"2.0","id":0}
EOF