//
//  OpenAIClient+models.swift
//  SereneCheck
//
//  Created by Edgar Alexis Negrete Hernandez on 15/03/23.
//

import Foundation

/**
Estructura que representa una solicitud a la API de OpenAI para generar una respuesta de ChatGPT.
*/
struct ChatCompletionRequest: Encodable {
    let model: String
    let messages: [Message]
    let maxTokens: Int
    
    private enum CodingKeys: String, CodingKey {
        case model
        case messages
        case maxTokens = "max_tokens"
    }
}

/**
Estructura que representa la respuesta de la API de OpenAI al realizar una solicitud de completado de chat. Contiene la información devuelta por la API, incluyendo el identificador de la solicitud, el modelo utilizado, las opciones de respuesta generadas y la información de uso.
*/
struct ChatCompletionResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]
}

struct Usage: Decodable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    private enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct Choice: Decodable {
    let message: Message
    let finishReason: String
    let index: Int

    private enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
        case index
    }
}

struct Message: Codable {
    let role: String
    let content: String
}

struct PromptResponse: Identifiable, Decodable {
    var id = UUID()
    let header: String
    let checklist: [String]
    let footer: String
    
    private enum CodingKeys: String, CodingKey {
        case header, checklist, footer
    }
  
  func isValidMood() -> Bool {
    return checklist.isEmpty && footer.isEmpty ? false : true
  }
}
