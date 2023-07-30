//
//  WordSearchController.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 18.7.23..
//

import Foundation

// Enum to represent the different search directions
enum SearchDirection: String, CaseIterable {
    case oldNorseToRussian
    case englishToOldNorse
    case oldNorseToEnglish
    case russianToOldNorse
}

// Function to return a string description of a search direction
func searchDiractionDesc(direction: SearchDirection) -> String {
    switch direction {
    case .englishToOldNorse:
        return "English to Old Norse"
    case .oldNorseToEnglish:
        return "Old Norse to English"
    case .russianToOldNorse:
        return "Russian to Old Norse"
    case .oldNorseToRussian:
        return "Old Norse to Russian"
    }
}

// Class to control the word search functionality
class WordSearchController: ObservableObject {
    // Published properties that will trigger UI updates when they change
    @Published var searchQuery: String = ""
    @Published var searchDirection: SearchDirection = .oldNorseToRussian
    @Published var selectedWordType: WordType?
    // Instance of WordService to handle word data operations
    var wordService: WordService

    // Computed property to return the filtered words based on the search query and selected word type
    var filteredWords: [Word] {
        if !searchQuery.isEmpty || selectedWordType != nil {
            return wordService.searchWords(for: searchQuery, searchDirection: searchDirection, wordType: selectedWordType)
        } else {
            // Show all loaded words when the search query is empty
            return wordService.words.sorted(by: {
                if $1.oldNorseWord > $0.oldNorseWord {
                    return true
                }
                return false
            })
        }
    }

    // Initializer
    init() {
        // Initialize WordService
        wordService = WordService()
    }
}
