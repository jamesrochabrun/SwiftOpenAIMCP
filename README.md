# SwiftOpenAI MCP Server

<img width="953" height="429" alt="Image" src="https://github.com/user-attachments/assets/4e0c7b30-eb23-4051-ab23-43021d075652" />

[![npm version](https://img.shields.io/npm/v/swiftopenai-mcp.svg)](https://www.npmjs.com/package/swiftopenai-mcp)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A universal MCP (Model Context Protocol) server that provides access to OpenAI's APIs through a standardized interface. Works with any MCP-compatible client including Claude Desktop, Claude Code, Cursor, Windsurf, VS Code, and more.

https://github.com/user-attachments/assets/d93f3700-f33d-42eb-8c23-4ad64fd359e1

## What is this?

This MCP server enables any AI assistant or development tool that supports the Model Context Protocol to interact with OpenAI's APIs. Once configured, your AI assistant can:
- Have conversations with GPT models
- Generate images with DALL-E
- Create embeddings for semantic search
- List available models
- Work with OpenAI-compatible providers (Groq, OpenRouter, etc.)

Built with Swift for high performance and reliability.

## 🚀 Features

- **Multi-Provider Support** - Works with 9+ AI providers including OpenAI, Anthropic, Google Gemini, Ollama, Groq, and more
- **Chat Completions** - Interact with GPT-5, GPT-4o, o3-mini, o3, Claude, Gemini, and other chat models
- **Advanced Model Control** - Fine-tune responses with reasoning effort and verbosity parameters
- **Image Generation** - Create images using DALL-E 2 and DALL-E 3
- **Embeddings** - Generate text embeddings for semantic search and analysis
- **Model Listing** - Retrieve available models from any provider

## 🌐 Supported Providers

This server works with any **OpenAI-compatible** API endpoint:

### Fully Compatible
- **OpenAI** (default) - GPT-5, GPT-4o, o3-mini, o3, DALL-E, embeddings
- **Azure OpenAI** - Enterprise OpenAI services with compatible endpoints
- **Ollama** - Local LLMs with OpenAI-compatible API (`/v1` endpoints)
- **Groq** - Fast inference using their OpenAI-compatible endpoint
- **OpenRouter** - Unified access to 100+ models via OpenAI format
- **DeepSeek** - Coding models with OpenAI-compatible API

### Requires Compatible Endpoints
These providers have their own APIs but may offer OpenAI-compatible endpoints:
- **Anthropic** - Check if they provide an OpenAI-compatible endpoint
- **Google Gemini** - May require specific configuration
- **xAI** - Check for OpenAI-compatible access

**Note**: Image generation (DALL-E) only works with OpenAI. Other providers may support different image models.

## 📦 Installation

### Via npm (Recommended)

```bash
npm install -g swiftopenai-mcp
```

### Prerequisites

- Node.js 16 or higher

## 🔧 Configuration

Add this configuration to your MCP client:

### OpenAI (default)
```json
{
  "mcpServers": {
    "swiftopenai": {
      "command": "npx",
      "args": ["-y", "swiftopenai-mcp"],
      "env": {
        "API_KEY": "sk-..."
      }
    }
  }
}
```

### Other Providers

**Groq** (fast open-source models):
```json
"env": {
  "API_KEY": "gsk_...",
  "API_BASE_URL": "https://api.groq.com/openai/v1"
}
```

**Ollama** (local models):
```json
"env": {
  "API_KEY": "ollama",
  "API_BASE_URL": "http://localhost:11434/v1"
}
```

**OpenRouter** (multiple providers):
```json
"env": {
  "API_KEY": "sk-or-v1-...",
  "API_BASE_URL": "https://openrouter.ai/api/v1"
}
```

### Where to add this configuration:

- **Claude Desktop**: 
  - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
  - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
- **Claude Code**: `.claude/mcp.json` in your project root
- **Cursor**: Settings → Features → MCP Servers
- **Windsurf**: MCP panel in settings
- **VS Code Continue**: Add to your `.continuerc.json` under the `models` array with an `mcpServers` property

## 🛠️ Available Tools

### chat_completion
Send messages to OpenAI GPT models and get responses.

**Parameters:**
- **messages** (required) - Array of conversation messages, each with:
  - role: "system", "user", or "assistant"
  - content: The message text
- **model** - Which model to use (default: "gpt-4o"). Examples:
  - GPT-5 family: gpt-5 (complex reasoning), gpt-5-mini (cost-optimized), gpt-5-nano (high-throughput)
  - GPT-4 family: gpt-4o, gpt-4o-mini
  - o3 family: o3, o3-mini
- **temperature** - Creativity level from 0-2 (default: 0.7). Lower = more focused, higher = more creative
- **max_tokens** - Maximum length of the response
- **reasoning_effort** - Control reasoning tokens for supported models:
  - "minimal": Very few reasoning tokens for fastest response (great for coding/instructions)
  - "low": Reduced reasoning effort
  - "medium": Balanced reasoning (default)
  - "high": Maximum reasoning effort
- **verbosity** - Control output token generation:
  - "low": Concise responses (e.g., simple code, SQL queries)
  - "medium": Balanced detail (default)
  - "high": Thorough explanations (e.g., detailed documentation, code refactoring)

**Example usage:**
- "Ask o3-mini to explain quantum computing in simple terms"
- "Use gpt-5 with high reasoning effort to solve this complex problem"
- "Generate concise code with gpt-5-mini using low verbosity"

### image_generation
Generate images using AI models.

**Parameters:**
- **prompt** (required) - Text description of the image you want
- **model** - Model to use (default: "dall-e-3"). Examples:
  - OpenAI: "dall-e-2", "dall-e-3"
  - Other providers: Use their specific model names
- **size** - Image dimensions (default: "1024x1024")
- **quality** - "standard" or "hd" (default: "standard")
- **n** - Number of images to generate (default: 1)

**Example usage:**
"Generate an HD image of a futuristic city at sunset"

**Note:** Image generation parameters like size and quality may vary by provider. Currently optimized for OpenAI's DALL-E models.

### list_models
List available models from your provider.

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

> **Note**: The exact way to invoke these tools depends on your MCP client.

### Chat Conversations

**Powerful use cases:**

**Get a second opinion from another AI:**
- "Send this entire conversation to gpt-5 with high reasoning effort and ask what it thinks"
- "Have gpt-4o analyze what we've discussed and suggest improvements"
- "Use gpt-5-mini with low verbosity for a quick summary"

**Deep analysis:**
- "Ask o3 to find any logical flaws in our reasoning so far"
- "Have o3-mini summarize the key decisions we've made"

**Cross-model collaboration:**
- "Get o3's perspective on this problem we're solving"
- "Ask gpt-4o to critique the code we just wrote"
- "Have o3-mini explain this differently for a beginner"

**Context-aware help:**
- "Based on our conversation, have o3 create a step-by-step tutorial"
- "Ask gpt-4o to generate test cases for the solution we discussed"

**Role-playing scenarios:**
- "Have o3-mini act as a senior developer and review our approach"
- "Ask gpt-4o to play devil's advocate on our architecture"
- "Get o3 to explain this as if teaching a computer science class"

### Image Generation

**Quick generations:**
- "Generate an image of a sunset over mountains"
- "Create a DALL-E 3 HD image of a futuristic city"

**Specific requests:**
- "Make a 1792x1024 image of a cozy coffee shop interior"
- "Generate a standard quality image of abstract art"

### Model Discovery

- "List all available models"
- "Show me only the GPT models"
- "What embedding models are available?"

### Embeddings

- "Create embeddings for: 'Revolutionary new smartphone with AI features'"
- "Generate embeddings for this product description: [your text]"

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

- **"Missing API key" error**: Set the `API_KEY` environment variable in your configuration
- **"Invalid API key" error**: Double-check your API key is correct and active
- **Timeout errors**: Some operations (like image generation) can take time; be patient
- **Rate limit errors**: You may be hitting your provider's rate limits; wait a bit and try again

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

## Support

- **Issues**: [GitHub Issues](https://github.com/jamesrochabrun/SwiftOpenAIMCP/issues)
- **Discussions**: [GitHub Discussions](https://github.com/jamesrochabrun/SwiftOpenAIMCP/discussions)

---
