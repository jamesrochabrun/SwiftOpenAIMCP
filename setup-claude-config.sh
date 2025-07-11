#!/bin/bash

# Safely set up Claude Desktop configuration

CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

echo "Setting up Claude Desktop configuration..."

# Check if config file exists
if [ -f "$CONFIG_FILE" ]; then
    echo "Found existing Claude Desktop config"
    echo "Current config:"
    cat "$CONFIG_FILE"
    echo ""
    echo "Please manually add the SwiftOpenAI server to your existing configuration."
else
    echo "Creating new Claude Desktop config"
    mkdir -p "$HOME/Library/Application Support/Claude"
fi

echo ""
echo "Add this to your claude_desktop_config.json:"
echo "============================================"
cat << 'EOF'
{
  "mcpServers": {
    "swiftopenai": {
      "command": "/Users/jamesrochabrun/Desktop/git/SwiftOpenAIMCP/.build/debug/swiftopenai-mcp",
      "args": [],
      "env": {
        "OPENAI_API_KEY": "sk-proj-YOUR_API_KEY_HERE"
      }
    }
  }
}
EOF

echo ""
echo "IMPORTANT SECURITY NOTES:"
echo "1. Replace 'sk-proj-YOUR_API_KEY_HERE' with your actual API key"
echo "2. Keep your API key secret - never share it"
echo "3. Consider using environment variables instead"
echo ""
echo "To use environment variable (more secure):"
echo '  "OPENAI_API_KEY": "${OPENAI_API_KEY}"'
echo ""
echo "Then set in your shell: export OPENAI_API_KEY='your-key'"