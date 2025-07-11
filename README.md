# SwiftOpenAI MCP Server

[![npm version](https://img.shields.io/npm/v/swiftopenai-mcp.svg)](https://www.npmjs.com/package/swiftopenai-mcp)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An MCP (Model Context Protocol) server that provides access to OpenAI's APIs through a standardized interface. Built with Swift for high performance and reliability.

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

### Claude Desktop

Add the following to your Claude Desktop configuration file:

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`  
**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

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

### VS Code with Continue Extension

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

### Alternative Providers

To use alternative OpenAI-compatible providers like Groq or OpenRouter:

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

## 🛠️ Available Tools

### 1. chat_completion

Send messages to OpenAI chat models and receive responses.

**Parameters:**
- `messages` (required): Array of message objects with `role` and `content`
  - `role`: "system", "user", or "assistant"
  - `content`: The message text
- `model`: Model to use (default: "gpt-4o")
- `temperature`: Sampling temperature 0-2 (default: 0.7)
- `max_tokens`: Maximum tokens to generate
- `stream`: Enable streaming responses (default: false)

**Example usage in Claude:**
```
Can you use SwiftOpenAI to ask GPT-4 to write a haiku about coding?
```

### 2. image_generation

Generate images using DALL-E models.

**Parameters:**
- `prompt` (required): Text description of the desired image
- `model`: "dall-e-2" or "dall-e-3" (default: "dall-e-3")
- `size`: Image dimensions
  - DALL-E 2: "1024x1024"
  - DALL-E 3: "1024x1024", "1792x1024", "1024x1792"
- `quality`: "standard" or "hd" (DALL-E 3 only, default: "standard")
- `n`: Number of images (1-10 for DALL-E 2, only 1 for DALL-E 3)

**Example usage in Claude:**
```
Please use SwiftOpenAI to generate an image of a futuristic city at sunset
```

### 3. list_models

List all available OpenAI models.

**Parameters:**
- `filter`: Optional string to filter model names

**Example usage in Claude:**
```
Can you use SwiftOpenAI to show me all available GPT models?
```

### 4. create_embedding

Generate embeddings for text input.

**Parameters:**
- `input` (required): Text to create embeddings for
- `model`: Embedding model (default: "text-embedding-ada-002")

**Example usage in Claude:**
```
Use SwiftOpenAI to create embeddings for "The quick brown fox jumps over the lazy dog"
```

## 💡 Usage Examples

### Basic Chat

Ask Claude to interact with GPT models:

```
Use SwiftOpenAI to ask GPT-4 to explain quantum computing in simple terms
```

### Image Generation

Request image creation:

```
Can you use SwiftOpenAI to create a DALL-E 3 HD image of a serene Japanese garden with cherry blossoms?
```

### Model Exploration

Discover available models:

```
Use SwiftOpenAI to list all available models and filter for "gpt"
```

### Multi-turn Conversations

You can maintain context across messages:

```
Use SwiftOpenAI to start a conversation:
- System: You are a helpful cooking assistant
- User: I want to make pasta for dinner
- Assistant: I'd be happy to help you make pasta! What type of pasta dish are you interested in?
- User: Something with tomatoes and basil
```

## 🔒 Security Best Practices

1. **Never share your API key** in public repositories or chat messages
2. **Use environment variables** when possible instead of hardcoding keys
3. **Rotate keys regularly** through the OpenAI dashboard
4. **Set usage limits** in your OpenAI account to prevent unexpected charges

## 🐛 Troubleshooting

### Server not starting

1. Check that your API key is correctly set in the configuration
2. Ensure you've restarted Claude Desktop after updating the config
3. Verify the npm package is installed: `npm list -g swiftopenai-mcp`

### No response from tools

1. Verify your API key has the necessary permissions
2. Check if you have available API credits
3. For alternative providers, ensure the base URL is correct

### View logs

Check Claude Desktop logs for debugging:
- macOS: `~/Library/Logs/Claude/mcp-*.log`
- Windows: `%APPDATA%\Claude\logs\mcp-*.log`

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