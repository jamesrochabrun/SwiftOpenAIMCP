import Foundation
import MCP
import SwiftOpenAI
import Logging
import ArgumentParser

@main
struct SwiftOpenAIMCPServer: AsyncParsableCommand {
  static let logger = Logger(label: "com.jamesrochabrun.swiftopenai-mcp")
  
  static let configuration = CommandConfiguration(
    commandName: "swiftopenai-mcp",
    abstract: "MCP server for SwiftOpenAI"
  )
  
  mutating func run() async throws {
    let server = Server(
      name: "SwiftOpenAI MCP Server",
      version: "1.0.0",
      capabilities: .init(
        tools: .init(listChanged: false)
      )
    )
    
    // Define available tools
    let tools = [
      Tool(
        name: "chat_completion",
        description: "Send messages to OpenAI GPT models and get responses",
        inputSchema: .object([
          "type": .string("object"),
          "properties": .object([
            "messages": .object([
              "type": .string("array"),
              "items": .object([
                "type": .string("object"),
                "properties": .object([
                  "role": .object([
                    "type": .string("string"),
                    "enum": .array([.string("system"), .string("user"), .string("assistant")])
                  ]),
                  "content": .object(["type": .string("string")])
                ]),
                "required": .array([.string("role"), .string("content")])
              ])
            ]),
            "model": .object([
              "type": .string("string"),
              "default": .string("gpt-4o"),
              "description": .string("Model to use (e.g., gpt-4o, gpt-4o-mini, gpt-3.5-turbo)")
            ]),
            "temperature": .object([
              "type": .string("number"),
              "default": .double(0.7),
              "description": .string("Sampling temperature (0-2)")
            ]),
            "max_tokens": .object([
              "type": .string("integer"),
              "description": .string("Maximum tokens to generate")
            ]),
            "stream": .object([
              "type": .string("boolean"),
              "default": .bool(false),
              "description": .string("Stream the response")
            ])
          ]),
          "required": .array([.string("messages")])
        ])
      ),
      Tool(
        name: "image_generation",
        description: "Generate images using DALL-E models",
        inputSchema: .object([
          "type": .string("object"),
          "properties": .object([
            "prompt": .object([
              "type": .string("string"),
              "description": .string("Text description of the image to generate")
            ]),
            "model": .object([
              "type": .string("string"),
              "enum": .array([.string("dall-e-2"), .string("dall-e-3")]),
              "default": .string("dall-e-3"),
              "description": .string("DALL-E model version")
            ]),
            "size": .object([
              "type": .string("string"),
              "enum": .array([.string("1024x1024"), .string("1792x1024"), .string("1024x1792")]),
              "default": .string("1024x1024"),
              "description": .string("Image size (dall-e-3 supports all sizes, dall-e-2 only 1024x1024)")
            ]),
            "quality": .object([
              "type": .string("string"),
              "enum": .array([.string("standard"), .string("hd")]),
              "default": .string("standard"),
              "description": .string("Image quality (dall-e-3 only)")
            ]),
            "n": .object([
              "type": .string("integer"),
              "default": .int(1),
              "description": .string("Number of images to generate (1-10 for dall-e-2, 1 for dall-e-3)")
            ])
          ]),
          "required": .array([.string("prompt")])
        ])
      ),
      Tool(
        name: "list_models",
        description: "List available OpenAI models",
        inputSchema: .object([
          "type": .string("object"),
          "properties": .object([
            "filter": .object([
              "type": .string("string"),
              "description": .string("Optional filter string to match model names")
            ])
          ])
        ])
      ),
      Tool(
        name: "create_embedding",
        description: "Create embeddings for text",
        inputSchema: .object([
          "type": .string("object"),
          "properties": .object([
            "input": .object([
              "type": .string("string"),
              "description": .string("Text to create embeddings for")
            ]),
            "model": .object([
              "type": .string("string"),
              "default": .string("text-embedding-ada-002"),
              "description": .string("Embedding model to use")
            ])
          ]),
          "required": .array([.string("input")])
        ])
      )
    ]
    
    // Initialize OpenAI service
    let openAIService: OpenAIServiceWrapper
    do {
      openAIService = try OpenAIServiceWrapper()
    } catch {
      Self.logger.error("Failed to initialize OpenAI service", metadata: ["error": "\(error)"])
      throw error
    }
    
    // Handle tool listing
    await server.withMethodHandler(ListTools.self) { _ in
      return ListTools.Result(tools: tools)
    }
    
    // Handle tool calls
    await server.withMethodHandler(CallTool.self) { params in
      do {
        let args = params.arguments.map { Value.object($0) }
        let result = try await openAIService.callTool(name: params.name, arguments: args)
        return CallTool.Result(content: [.text(result)], isError: false)
      } catch {
        Self.logger.error("Tool execution failed", metadata: ["error": "\(error)"])
        return CallTool.Result(content: [.text("Error: \(error.localizedDescription)")], isError: true)
      }
    }
    
    // Set up transport and run server
    let transport = StdioTransport(logger: Self.logger)
    try await server.start(transport: transport)
    
    // Keep the server running indefinitely (as recommended in MCP SDK docs)
    // This is the official pattern from the documentation
    do {
      try await Task.sleep(for: .seconds(86400 * 365 * 100))  // Effectively forever (100 years)
    } catch {
      // Task was cancelled, exit gracefully
      Self.logger.info("Server shutting down gracefully")
    }
  }
}

// OpenAI Service Wrapper implementation
final class OpenAIServiceWrapper: @unchecked Sendable {
  private let apiKey: String
  private let baseURL: String?
  private let openAIService: OpenAIService
  
  init() throws {
    guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
      throw OpenAIServiceError.missingAPIKey
    }
    
    self.apiKey = apiKey
    self.baseURL = ProcessInfo.processInfo.environment["API_BASE_URL"]
    
    if let baseURL = baseURL {
      self.openAIService = OpenAIServiceFactory.service(apiKey: .apiKey(apiKey), baseURL: baseURL)
    } else {
      self.openAIService = OpenAIServiceFactory.service(apiKey: apiKey)
    }
  }
  
  func callTool(name: String, arguments: Value?) async throws -> String {
    switch name {
    case "chat_completion":
      return try await performChatCompletion(arguments: arguments)
    case "image_generation":
      return try await performImageGeneration(arguments: arguments)
    case "list_models":
      return try await performListModels(arguments: arguments)
    case "create_embedding":
      return try await performCreateEmbedding(arguments: arguments)
    default:
      throw OpenAIServiceError.unknownTool(name)
    }
  }
  
  private func performChatCompletion(arguments: Value?) async throws -> String {
    guard let args = arguments?.objectValue else {
      throw OpenAIServiceError.invalidArguments
    }
    
    // Parse messages
    guard let messagesArray = args["messages"]?.arrayValue else {
      throw OpenAIServiceError.missingRequiredField("messages")
    }
    
    var messages: [ChatCompletionParameters.Message] = []
    for messageValue in messagesArray {
      guard let messageObj = messageValue.objectValue,
            let role = messageObj["role"]?.stringValue,
            let content = messageObj["content"]?.stringValue else {
        throw OpenAIServiceError.invalidMessageFormat
      }
      
      let message = ChatCompletionParameters.Message(
        role: ChatCompletionParameters.Message.Role(rawValue: role) ?? .user,
        content: .text(content)
      )
      messages.append(message)
    }
    
    // Parse optional parameters
    let model = args["model"]?.stringValue ?? "gpt-4o"
    let temperature = args["temperature"]?.doubleValue
    let maxTokens = args["max_tokens"]?.intValue
    let stream = args["stream"]?.boolValue ?? false
    
    let parameters = ChatCompletionParameters(
      messages: messages,
      model: .custom(model),
      maxTokens: maxTokens,
      temperature: temperature
    )
    
    if stream {
      var fullResponse = ""
      let stream = try await openAIService.startStreamedChat(parameters: parameters)
      
      for try await chunk in stream {
        if let content = chunk.choices?.first?.delta?.content {
          fullResponse += content
        }
      }
      
      return fullResponse
    } else {
      let response = try await openAIService.startChat(parameters: parameters)
      guard let firstChoice = response.choices?.first else {
        return "No response"
      }
      
      return firstChoice.message?.content ?? "No response"
    }
  }
  
  private func performImageGeneration(arguments: Value?) async throws -> String {
    guard let args = arguments?.objectValue else {
      throw OpenAIServiceError.invalidArguments
    }
    
    guard let prompt = args["prompt"]?.stringValue else {
      throw OpenAIServiceError.missingRequiredField("prompt")
    }
    
    let model = args["model"]?.stringValue ?? "dall-e-3"
    let size = args["size"]?.stringValue ?? "1024x1024"
    let quality = args["quality"]?.stringValue ?? "standard"
    let n = args["n"]?.intValue ?? 1
    
    // Use custom model to support any provider's image models
    let imageModel: CreateImageParameters.Model = .custom(model)
    let imageQuality: CreateImageParameters.Quality = quality == "hd" ? .hd : .standard
    
    let parameters = CreateImageParameters(
      prompt: prompt,
      model: imageModel,
      n: n,
      quality: imageQuality,
      size: size
    )
    
    do {
      let response = try await openAIService.createImages(parameters: parameters)
      
      let urls = response.data?.compactMap { $0.url }.joined(separator: "\n") ?? ""
      return "Generated \(response.data?.count ?? 0) image(s):\n\(urls)"
    } catch {
      // Check for common errors indicating unsupported feature
      let errorMessage = error.localizedDescription.lowercased()
      
      if errorMessage.contains("404") || errorMessage.contains("not found") {
        return "Image generation is not supported by this provider. This feature requires a provider with image generation capabilities (e.g., OpenAI with DALL-E)."
      }
      
      if errorMessage.contains("method not allowed") || errorMessage.contains("405") {
        return "This provider does not support image generation. Try using OpenAI or another provider with image capabilities."
      }
      
      // Re-throw for generic error handling
      throw error
    }
  }
  
  private func performListModels(arguments: Value?) async throws -> String {
    let filter = arguments?.objectValue?["filter"]?.stringValue
    
    do {
      let models = try await openAIService.listModels()
      
      var modelList = models.data
      if let filter = filter {
        modelList = modelList.filter { $0.id.lowercased().contains(filter.lowercased()) }
      }
      
      let sortedModels = modelList.sorted { $0.id < $1.id }
      let modelNames = sortedModels.map { $0.id }.joined(separator: "\n")
      
      if modelNames.isEmpty {
        return "No models found. This provider may not support model listing or may require different authentication."
      }
      
      return "Available models:\n\(modelNames)"
    } catch {
      // Check for common errors indicating unsupported feature
      let errorMessage = error.localizedDescription.lowercased()
      
      if errorMessage.contains("404") || errorMessage.contains("not found") {
        return "Model listing is not supported by this provider. You can still use the chat tool by specifying a model name directly."
      }
      
      if errorMessage.contains("method not allowed") || errorMessage.contains("405") {
        return "This provider does not support listing models. Check the provider's documentation for available model names."
      }
      
      // Re-throw for generic error handling
      throw error
    }
  }
  
  private func performCreateEmbedding(arguments: Value?) async throws -> String {
    guard let args = arguments?.objectValue else {
      throw OpenAIServiceError.invalidArguments
    }
    
    guard let input = args["input"]?.stringValue else {
      throw OpenAIServiceError.missingRequiredField("input")
    }
    
    let model = args["model"]?.stringValue ?? "text-embedding-ada-002"
    
    // Use custom model to support any provider's embedding models
    let parameters = EmbeddingParameter(
      input: input,
      model: .custom(model),
      encodingFormat: nil,
      dimensions: nil
    )
    
    do {
      let response = try await openAIService.createEmbeddings(parameters: parameters)
      
      guard let embedding = response.data.first else {
        throw OpenAIServiceError.noEmbeddingGenerated
      }
      
      return """
          Embedding generated:
          Model: \(response.model ?? "unknown")
          Dimensions: \(embedding.embedding.count)
          First 10 values: \(embedding.embedding.prefix(10).map { String(format: "%.4f", $0) }.joined(separator: ", "))...
          Total tokens: \(response.usage?.totalTokens ?? 0)
          """
    } catch {
      // Check for common errors indicating unsupported feature
      let errorMessage = error.localizedDescription.lowercased()
      
      if errorMessage.contains("404") || errorMessage.contains("not found") {
        return "Embeddings are not supported by this provider. This feature requires a provider with embedding capabilities (e.g., OpenAI, Cohere)."
      }
      
      if errorMessage.contains("method not allowed") || errorMessage.contains("405") {
        return "This provider does not support creating embeddings. Try using OpenAI or another provider with embedding support."
      }
      
      // Re-throw for generic error handling
      throw error
    }
  }
}
