//
//  WordSearchControllerTests.swift
//  OldNorseDictionaryTests
//
//  Created by Andrey Skurlatov on 30.7.23..
//

import XCTest
@testable import OldNorseDictionary

class WordSearchControllerTests: XCTestCase {

    var wordSearchController: WordSearchController!

    override func setUp() {
        super.setUp()
        wordSearchController = WordSearchController()
    }

    override func tearDown() {
        wordSearchController = nil
        super.tearDown()
    }

    func testSearchQuery() {
        // Test that the search query is updated correctly
        let testQuery = "test"
        wordSearchController.searchQuery = testQuery
        XCTAssertEqual(wordSearchController.searchQuery, testQuery)
    }

    func testSearchDirection() {
        // Test that the search direction is updated correctly
        let testDirection = SearchDirection.englishToOldNorse
        wordSearchController.searchDirection = testDirection
        XCTAssertEqual(wordSearchController.searchDirection, testDirection)
    }

    func testSelectedWordType() {
        // Test that the selected word type is updated correctly
        let testWordType = WordType.noun // Replace with a valid word type
        wordSearchController.selectedWordType = testWordType
        XCTAssertEqual(wordSearchController.selectedWordType, testWordType)
    }

    func testFilteredWords() {
        // Test that the filtered words are updated correctly based on the search query
        let testQuery = "specificWord"
        wordSearchController.searchQuery = testQuery
        let filteredWords = wordSearchController.filteredWords
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains(testQuery))
        }

        // Test that the filtered words are updated correctly when the search query is empty
        wordSearchController.searchQuery = ""
        let allWords = wordSearchController.filteredWords
        XCTAssertEqual(allWords.count, wordSearchController.wordService.words.count)
    }
}

