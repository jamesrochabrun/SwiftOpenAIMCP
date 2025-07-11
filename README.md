# SwiftOpenAI MCP Server

[![npm version](https://img.shields.io/npm/v/swiftopenai-mcp.svg)](https://www.npmjs.com/package/swiftopenai-mcp)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A universal MCP (Model Context Protocol) server that provides access to OpenAI's APIs through a standardized interface. Works with any MCP-compatible client including Claude Desktop, Claude Code, Cursor, Windsurf, VS Code, and more.

## What is this?

This MCP server enables any AI assistant or development tool that supports the Model Context Protocol to interact with OpenAI's APIs. Once configured, your AI assistant can:
- Have conversations with GPT models
- Generate images with DALL-E
- Create embeddings for semantic search
- List available models
- Work with OpenAI-compatible providers (Groq, OpenRouter, etc.)

Built with Swift for high performance and reliability.

## 🚀 Features

- **Chat Completions** - Interact with GPT-4, GPT-3.5, and other chat models
- **Image Generation** - Create images using DALL-E 2 and DALL-E 3
- **Embeddings** - Generate text embeddings for semantic search and analysis
- **Model Listing** - Retrieve available OpenAI models
- **Streaming Support** - Real-time streaming responses for chat completions
- **Alternative Providers** - Support for OpenAI-compatible APIs (Groq, OpenRouter, etc.)

## 📦 Installation

### Via npm (Recommended)

```bash
npm install -g swiftopenai-mcp
```

### Prerequisites

- Node.js 16 or higher
- An OpenAI API key (get one at [platform.openai.com](https://platform.openai.com))

## 🔧 Configuration

### Basic Configuration

The SwiftOpenAI MCP server uses the standard MCP configuration format. Here's the basic structure:

```json
{
  "mcpServers": {
    "swiftopenai": {
      "command": "npx",
      "args": ["-y", "swiftopenai-mcp"],
      "env": {
        "OPENAI_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

### Alternative Providers

To use OpenAI-compatible providers like Groq, OpenRouter, or others:

```json
{
  "mcpServers": {
    "swiftopenai": {
      "command": "npx",
      "args": ["-y", "swiftopenai-mcp"],
      "env": {
        "OPENAI_API_KEY": "your-provider-api-key",
        "OPENAI_BASE_URL": "https://api.groq.com/openai/v1"
      }
    }
  }
}
```

### Examples for Popular Clients

#### Claude Desktop

Add to your configuration file:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`  
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "swiftopenai": {
      "command": "npx",
      "args": ["-y", "swiftopenai-mcp"],
      "env": {
        "OPENAI_API_KEY": "sk-proj-..."
      }
    }
  }
}
```

#### Claude Code

Claude Code automatically detects MCP servers. Add to your project's `.claude/mcp.json`:

```json
{
  "mcpServers": {
    "swiftopenai": {
      "command": "npx",
      "args": ["-y", "swiftopenai-mcp"],
      "env": {
        "OPENAI_API_KEY": "sk-proj-..."
      }
    }
  }
}
```

#### Cursor

Add to your Cursor settings under MCP Servers:

```json
{
  "mcpServers": {
    "swiftopenai": {
      "command": "npx",
      "args": ["-y", "swiftopenai-mcp"],
      "env": {
        "OPENAI_API_KEY": "sk-proj-..."
      }
    }
  }
}
```

#### Windsurf

Configure in Windsurf's MCP settings:

```json
{
  "mcpServers": {
    "swiftopenai": {
      "command": "npx",
      "args": ["-y", "swiftopenai-mcp"],
      "env": {
        "OPENAI_API_KEY": "sk-proj-..."
      }
    }
  }
}
```

#### VS Code with Continue Extension

Add to your Continue configuration:

```json
{
  "models": [
    {
      "title": "Claude with OpenAI Tools",
      "provider": "anthropic",
      "model": "claude-3-5-sonnet-20241022",
      "mcpServers": {
        "swiftopenai": {
          "command": "npx",
          "args": ["-y", "swiftopenai-mcp"],
          "env": {
            "OPENAI_API_KEY": "sk-proj-..."
          }
        }
      }
    }
  ]
}
```

## 🛠️ Available Tools

### chat_completion
Send messages to OpenAI GPT models and get responses.

**Parameters:**
- **messages** (required) - Array of conversation messages, each with:
  - role: "system", "user", or "assistant"
  - content: The message text
- **model** - Which model to use (default: "gpt-4o"). Examples: gpt-4o, o3-mini, o3
- **temperature** - Creativity level from 0-2 (default: 0.7). Lower = more focused, higher = more creative
- **max_tokens** - Maximum length of the response
- **stream** - Whether to stream the response in real-time (default: false)

**Example usage:**
"Use the chat tool to ask o3-mini to explain quantum computing in simple terms"

### image_generation
Generate images using DALL-E models.

**Parameters:**
- **prompt** (required) - Text description of the image you want
- **model** - "dall-e-2" or "dall-e-3" (default: "dall-e-3")
- **size** - Image dimensions:
  - DALL-E 2: Only "1024x1024"
  - DALL-E 3: "1024x1024", "1792x1024", or "1024x1792"
- **quality** - "standard" or "hd" (DALL-E 3 only, default: "standard")
- **n** - Number of images to generate (1-10 for DALL-E 2, only 1 for DALL-E 3)

**Example usage:**
"Generate an HD image of a futuristic city at sunset using DALL-E 3"

### list_models
List available OpenAI models.

**Parameters:**
- **filter** - Optional text to filter model names (e.g., "gpt" to see only GPT models)

**Example usage:**
"List all available models" or "Show me all GPT models"

### create_embedding
Create embeddings for text.

**Parameters:**
- **input** (required) - The text to create embeddings for
- **model** - Embedding model to use (default: "text-embedding-ada-002")

**Example usage:**
"Create embeddings for the text 'The quick brown fox jumps over the lazy dog'"

## 💡 Usage Examples

> **Note**: The exact way to invoke these tools depends on your MCP client. These examples show how you might naturally ask for these tools.

### Basic Chat

"Use the chat tool to ask o3-mini to explain quantum computing in simple terms"

"Have gpt-4o write a poem about the ocean"

"Ask o3 to help me debug this Python code: [paste code]"

### Image Generation

"Generate an HD image of a serene Japanese garden with cherry blossoms"

"Create a DALL-E 3 image of a futuristic spaceship in 1792x1024 resolution"

"Make a standard quality image of a cozy coffee shop interior"

### Model Exploration

"List all available models"

"Show me only the GPT models"

"What embedding models are available?"

### Multi-turn Conversations

"Use the chat tool to have a cooking conversation:
- First set the system message: 'You are a helpful cooking assistant'
- Then ask: 'I want to make pasta for dinner'
- Continue the conversation based on the response"

### Embeddings

"Create embeddings for my product description: 'Eco-friendly water bottle made from recycled materials'"

"Generate embeddings for this paragraph about machine learning"

## 🔒 Security Best Practices

1. **Never share your API key** in public repositories or chat messages
2. **Use environment variables** when possible instead of hardcoding keys
3. **Rotate keys regularly** through the OpenAI dashboard
4. **Set usage limits** in your OpenAI account to prevent unexpected charges

## 🐛 Troubleshooting

### Server not starting

1. **Check API key**: Ensure your API key is correctly set in the configuration
2. **Restart your client**: Most MCP clients require a restart after configuration changes
3. **Verify installation**: Check if the package is installed: `npm list -g swiftopenai-mcp`
4. **Check permissions**: Ensure the npm global directory has proper permissions

### No response from tools

1. **API key permissions**: Verify your API key has the necessary permissions
2. **API credits**: Check if you have available API credits in your OpenAI account
3. **Alternative providers**: For non-OpenAI providers, ensure the base URL is correct
4. **Network issues**: Check if you can reach the API endpoint from your network

### Debugging

#### Check MCP server output
Most MCP clients provide ways to view server logs. For example:

**Claude Desktop logs:**
- macOS: `~/Library/Logs/Claude/mcp-*.log`
- Windows: `%APPDATA%\Claude\logs\mcp-*.log`

**Other clients:** Check your client's documentation for log locations.

#### Test the server directly
You can test if the server starts correctly:
```bash
npx swiftopenai-mcp
```
This should output the MCP initialization message.

### Common Issues

- **"Missing API key" error**: Set the `OPENAI_API_KEY` environment variable in your configuration
- **"Invalid API key" error**: Double-check your API key is correct and active
- **Timeout errors**: Some operations (like image generation) can take time; be patient
- **Rate limit errors**: You may be hitting OpenAI's rate limits; wait a bit and try again

## 🏗️ Building from Source

If you want to build the server yourself:

```bash
git clone https://github.com/jamesrochabrun/SwiftOpenAIMCP.git
cd SwiftOpenAIMCP
swift build -c release
```

The binary will be at `.build/release/swiftopenai-mcp`

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Built with [SwiftOpenAI](https://github.com/jamesrochabrun/SwiftOpenAI)
- Implements the [Model Context Protocol](https://modelcontextprotocol.io)
- Uses the [MCP Swift SDK](https://github.com/modelcontextprotocol/swift-sdk)

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/jamesrochabrun/SwiftOpenAIMCP/issues)
- **Discussions**: [GitHub Discussions](https://github.com/jamesrochabrun/SwiftOpenAIMCP/discussions)

---

Made with ❤️ by [James Rochabrun](https://github.com/jamesrochabrun)