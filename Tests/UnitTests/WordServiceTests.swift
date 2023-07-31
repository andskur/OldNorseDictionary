//
//  WordServiceTests.swift
//  OldNorseDictionaryTests
//
//  Created by Andrey Skurlatov on 30.7.23..
//

import XCTest
@testable import OldNorseDictionary

class WordServiceTests: XCTestCase {

    var wordService: WordService!

    override func setUp() {
        super.setUp()
        wordService = WordService()
    }

    override func tearDown() {
        wordService = nil
        super.tearDown()
    }

    func testLoadWordsData() {
        wordService.loadWords()
        XCTAssertFalse(wordService.words.isEmpty)
    }

    func testFilterWords() {
        // Load the words data
        wordService.loadWords()

        // Test case 1: Test that a specific query returns the correct words
        var filteredWords = wordService.filterWords(wordService.words, with: "brandr", searchDirection: .oldNorseToRussian)
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains("brandr"))
        }

        // Test case 2: Test that a query with no matches returns an empty array
        filteredWords = wordService.filterWords(wordService.words, with: "noMatches", searchDirection: .oldNorseToRussian)
        XCTAssertTrue(filteredWords.isEmpty)

        filteredWords = wordService.filterWords(wordService.words, with: "brandar", searchDirection: .oldNorseToRussian)
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains("brandr"))
        }
        
        filteredWords = wordService.filterWords(wordService.words, with: "brand", searchDirection: .oldNorseToRussian)
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains("brandr"))
        }
        
        filteredWords = wordService.filterWords(wordService.words, with: "branda", searchDirection: .oldNorseToRussian)
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains("brandr"))
        }
        
        filteredWords = wordService.filterWords(wordService.words, with: "brandum", searchDirection: .oldNorseToRussian)
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains("brandr"))
        }
        
        filteredWords = wordService.filterWords(wordService.words, with: "hefi", searchDirection: .oldNorseToRussian)
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains("hafa"))
        }
        
        filteredWords = wordService.filterWords(wordService.words, with: "höfum", searchDirection: .oldNorseToRussian)
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains("hafa"))
        }
        
        filteredWords = wordService.filterWords(wordService.words, with: "hefir", searchDirection: .oldNorseToRussian)
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains("hafa"))
        }
        
        filteredWords = wordService.filterWords(wordService.words, with: "hafið", searchDirection: .oldNorseToRussian)
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains("hafa"))
        }
        
        filteredWords = wordService.filterWords(wordService.words, with: "hafa", searchDirection: .oldNorseToRussian)
        for word in filteredWords {
            XCTAssertTrue(word.oldNorseWord.contains("hafa"))
        }
    }


    func testSearchWords() {
        // Load the words data
        wordService.loadWords()

        // Test case 1: Test that an empty query returns all words
        var searchedWords = wordService.searchWords(for: "", searchDirection: .oldNorseToRussian, wordType: nil)
        XCTAssertEqual(searchedWords.count, wordService.words.count)
        
        // Test case 2: Test that a specific query returns the correct words
        searchedWords = wordService.searchWords(for: "brandr", searchDirection: .oldNorseToRussian, wordType: nil)
        for word in searchedWords {
            XCTAssertTrue(word.oldNorseWord.contains("brandr"))
        }

        // Test case 3: Test that a query with no matches returns an empty array
        searchedWords = wordService.searchWords(for: "noMatches", searchDirection: .oldNorseToRussian, wordType: nil)
        XCTAssertTrue(searchedWords.isEmpty)

        // Test case 4: Test that a specific word type returns the correct words
        let specificWordType = WordType.adverb // Replace with a valid word type
        searchedWords = wordService.searchWords(for: "", searchDirection: .oldNorseToRussian, wordType: specificWordType)
        for word in searchedWords {
            XCTAssertEqual(word.type, specificWordType)
        }
    }
}
