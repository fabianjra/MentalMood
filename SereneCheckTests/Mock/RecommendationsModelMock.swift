//
//  RecommendationsModelMock.swift
//  SereneCheckTests
//
//  Created by Alan Anaya Araujo on 17/03/23.
//

import Foundation
import XCTest
@testable import SereneCheck

protocol RecommendationsModelProtocol {
    func getRecomendations(for prompt: String, completionHandler: @escaping (PromptResponse?) -> Void)
}

class MockRecommendationsModel: RecommendationsModelProtocol {
    var expectation: XCTestExpectation?
    var shouldFail: Bool = false
    var lastPrompt: String?
    var lastCompletionHandler: ((PromptResponse?) -> Void)?
    
    func getRecomendations(for prompt: String, completionHandler: @escaping (PromptResponse?) -> Void) {
        lastPrompt = prompt
        lastCompletionHandler = completionHandler
        
        if shouldFail {
            completionHandler(nil)
        } else {
            let response = PromptResponse(header: "Here are your recommendations for improving your mood:",
                                          checklist: ["1. Go for a walk outside",
                                                      "2. Listen to some uplifting music",
                                                      "3. Practice gratitude journaling"],
                                          footer: "")
            completionHandler(response)
        }
        
        expectation?.fulfill()
    }
}
