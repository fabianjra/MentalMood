//
//  SereneCheckTests.swift
//  SereneCheckTests
//
//  Created by Fabian Josue Rodriguez Alvarez on 15/3/23.
//

import XCTest
@testable import SereneCheck

class RecommendationsViewModelTests: XCTestCase {
    var sut: MockRecommendationsModel!
    
    override func setUp() {
        super.setUp()
        sut = MockRecommendationsModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testGetRecommendationsWithValidPrompt() {
        // Given
        let prompt = "I'm feeling down today"
        let expectation = XCTestExpectation(description: "Completion handler called")
        sut.expectation = expectation
        
        // When
        sut.getRecomendations(for: prompt) { _ in
            
        }
        
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(sut.lastPrompt)
        XCTAssertEqual(sut.lastPrompt, prompt)
        XCTAssertNotNil(sut.lastCompletionHandler)
        XCTAssertFalse(sut.shouldFail)
    }
    
    func testGetRecommendationsWithInvalidPrompt() {
        // Given
        let prompt = ""
        let expectation = XCTestExpectation(description: "Completion handler called")
        sut.expectation = expectation
        sut.shouldFail = true
        
        // When
        sut.getRecomendations(for: prompt) { _ in
            
        }
        
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(sut.lastPrompt)
        XCTAssertEqual(sut.lastPrompt, prompt)
        XCTAssertNotNil(sut.lastCompletionHandler)
        XCTAssertTrue(sut.shouldFail)
    }
}
