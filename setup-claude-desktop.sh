#!/bin/bash

echo "Setting up SwiftOpenAI MCP for Claude Desktop"
echo "============================================="

# Check if Claude Desktop config directory exists
CONFIG_DIR="$HOME/Library/Application Support/Claude"
CONFIG_FILE="$CONFIG_DIR/claude_desktop_config.json"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Error: Claude Desktop config directory not found at: $CONFIG_DIR"
    echo "Please make sure Claude Desktop is installed"
    exit 1
fi

# Build the server
echo "Building SwiftOpenAI MCP server..."
swift build

if [ $? -ne 0 ]; then
    echo "Error: Build failed"
    exit 1
fi

echo ""
echo "Build successful!"
echo ""
echo "To use with Claude Desktop, you need to add this configuration to:"
echo "$CONFIG_FILE"
echo ""
echo "Configuration to add:"
echo ""
cat << 'EOF'
{
  "mcpServers": {
    "swiftopenai": {
      "command": "/Users/jamesrochabrun/Desktop/git/SwiftOpenAIMCP/.build/debug/swiftopenai-mcp",
      "args": [],
      "env": {
        "OPENAI_API_KEY": "YOUR_ACTUAL_API_KEY_HERE"
      }
    }
  }
}
EOF

echo ""
echo "IMPORTANT:"
echo "1. Replace YOUR_ACTUAL_API_KEY_HERE with your OpenAI API key"
echo "2. If you already have other servers configured, add this to the existing mcpServers object"
echo "3. Restart Claude Desktop after updating the configuration"
echo ""
echo "After restarting Claude, you can test by asking:"
echo "- 'Use SwiftOpenAI to list available models'"
echo "- 'Use SwiftOpenAI to generate an image of a sunset'"