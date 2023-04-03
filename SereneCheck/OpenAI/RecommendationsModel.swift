//
//  OpenAIService.swift
//  SereneCheck
//
//  Created by Edgar Alexis Negrete Hernandez on 15/03/23.
//

import Foundation

class RecommendationsModel: ObservableObject {
    
    func getRecomendations(for prompt: String, completionHandler: @escaping (PromptResponse?) -> Void) {
        
        print("Llamando al bot.......:")
        let systemMessage = NSLocalizedString("rules.header", comment: "") +
                            NSLocalizedString("rules.line.1", comment: "") +
                            NSLocalizedString("rules.line.2", comment: "") +
                            NSLocalizedString("rules.line.3", comment: "") +
                            NSLocalizedString("rules.line.4", comment: "") +
                            NSLocalizedString("rules.line.5", comment: "") +
                            NSLocalizedString("rules.line.6", comment: "") +
                            NSLocalizedString("rules.line.7", comment: "") +
                            NSLocalizedString("rules.line.8", comment: "") +
                            NSLocalizedString("rules.line.9", comment: "")
        let userLabel = NSLocalizedString("user.label", comment: "")
        let jsonResp = NSLocalizedString("json.response", comment: "")
        
        OpenAIClient().sendRequest(
            messages: [
                Message(role: "system", content: systemMessage),
                Message(role: "user", content: userLabel + prompt),
                Message(role: "assistant", content: jsonResp)
            ]
        ) { (response, error) in
            guard error == nil else {
                print("There was an error in the OpenAI call.")
                print(error?.localizedDescription ?? "")
                completionHandler(nil)
                return
            }
            
            if let promptJson = response?.choices.first?.message.content,
               let data = promptJson.data(using: String.Encoding.utf8) {
                let decoder = JSONDecoder()
                
                do {
                    let promptResponse = try decoder.decode(PromptResponse.self, from: data)
                    
                    print(promptResponse)
                    completionHandler(promptResponse)
                } catch {
                    print(error)
                    completionHandler(nil)
                }
            } else {
                print("There was an error getting the content of the bot message")
                completionHandler(nil)
            }
        }
    }
}
