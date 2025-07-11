// This file was created to move OpenAIServiceError out of main.swift to resolve '@main' attribute issues.

import Foundation

enum OpenAIServiceError: LocalizedError {
  case missingAPIKey
  case unknownTool(String)
  case invalidArguments
  case missingRequiredField(String)
  case invalidMessageFormat
  case invalidRole(String)
  case noEmbeddingGenerated
  
  var errorDescription: String? {
    switch self {
    case .missingAPIKey:
      return "API_KEY environment variable is not set"
    case .unknownTool(let name):
      return "Unknown tool: \(name)"
    case .invalidArguments:
      return "Invalid arguments provided"
    case .missingRequiredField(let field):
      return "Missing required field: \(field)"
    case .invalidMessageFormat:
      return "Invalid message format"
    case .invalidRole(let role):
      return "Invalid role: \(role)"
    case .noEmbeddingGenerated:
      return "No embedding was generated"
    }
  }
}
