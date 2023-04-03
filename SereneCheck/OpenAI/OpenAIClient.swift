//
//  OpenAIClient.swift
//  SereneCheck
//
//  Created by Edgar Alexis Negrete Hernandez on 15/03/23.
//

import Foundation

class OpenAIClient {
    let endpoint = "https://api.openai.com/v1/chat/completions"
    private var apiKey: String {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        return value
    }
    
    func sendRequest(messages: [Message], completion: @escaping (ChatCompletionResponse?, Error?) -> Void) {
        let request = createRequest(messages: messages)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, NSError(domain: "OpenAIClientError", code: 0, userInfo: nil))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NSError(domain: "OpenAIClientError", code: httpResponse.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "OpenAIClientError", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ChatCompletionResponse.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    private func createRequest(messages: [Message]) -> URLRequest {
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let requestBody = ChatCompletionRequest(model: "gpt-3.5-turbo",
                                         messages: messages,
                                         maxTokens: 300)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(requestBody)
            request.httpBody = jsonData
        } catch {
            Log.writeCatchExeption(error: error)
        }
        
        return request
    }
}
