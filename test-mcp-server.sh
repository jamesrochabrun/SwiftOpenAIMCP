#!/bin/bash

# Test script for SwiftOpenAI MCP Server
# This script sends MCP protocol messages and displays responses

# Set your OpenAI API key
export OPENAI_API_KEY="${OPENAI_API_KEY:-your-api-key-here}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Testing SwiftOpenAI MCP Server${NC}"
echo "================================"

# Function to send a message and display response
send_message() {
    local message="$1"
    local description="$2"
    
    echo -e "\n${GREEN}Test: $description${NC}"
    echo "Request:"
    echo "$message" | jq .
    echo -e "\nResponse:"
    echo "$message" | ./.build/debug/swiftopenai-mcp 2>&1
    echo "--------------------------------"
}

# Test 1: Initialize
INIT_MSG='{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2025-06-18",
    "capabilities": {},
    "clientInfo": {
      "name": "test-client",
      "version": "1.0"
    }
  }
}'

send_message "$INIT_MSG" "Initialize connection"

# Test 2: List available tools
LIST_TOOLS_MSG='{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/list",
  "params": {}
}'

send_message "$LIST_TOOLS_MSG" "List available tools"

# Test 3: Call list_models tool
LIST_MODELS_MSG='{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "tools/call",
  "params": {
    "name": "list_models",
    "arguments": {}
  }
}'

send_message "$LIST_MODELS_MSG" "List OpenAI models"

# Test 4: Call chat_completion tool
CHAT_MSG='{
  "jsonrpc": "2.0",
  "id": 4,
  "method": "tools/call",
  "params": {
    "name": "chat_completion",
    "arguments": {
      "messages": [
        {"role": "user", "content": "Say hello in one word"}
      ],
      "model": "gpt-3.5-turbo",
      "max_tokens": 10
    }
  }
}'

send_message "$CHAT_MSG" "Simple chat completion"

echo -e "\n${BLUE}Tests completed!${NC}"