//
//  WordSearchControllerTests.swift
//  OldNorseDictionaryTests
//
//  Created by Andrey Skurlatov on 21.7.23..
//

import XCTest
@testable import OldNorseDictionary // Assuming this is the module name where WordSearchController is located

final class WordSearchControllerTests: XCTestCase {
    
    var wordSearchController: WordSearchController!

    override func setUp() {
        super.setUp()
        wordSearchController = WordSearchController()
    }
    
    override func tearDown() {
        wordSearchController = nil
        super.tearDown()
    }
    
    func testDefaultWordList() {
        // Ensure the default list of words is loaded properly
        XCTAssertEqual(wordSearchController.loadedWords.count, 177) // Change 200 to the expected number of words in the file
    }
    
    func testFilterBySearchQuery() {
        // Test filtering by search query
        wordSearchController.searchQuery = "álfr"
        wordSearchController.searchDirection = .oldNorseToRussian
        let filteredWords = wordSearchController.filteredWords
        XCTAssertTrue(filteredWords.contains { $0.oldNorseWord.lowercased() == "álfr" })
    }
    
    // Add more test methods to cover other scenarios and edge cases

}
