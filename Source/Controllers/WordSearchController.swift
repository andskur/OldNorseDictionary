//
//  WordSearchController.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 18.7.23..
//

import Foundation

enum SearchDirection: String, CaseIterable {
    case oldNorseToRussian
    case englishToOldNorse
    case oldNorseToEnglish
    case russianToOldNorse
}

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

class WordSearchController: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchDirection: SearchDirection = .oldNorseToRussian
    @Published var selectedWordType: WordType?
    private var wordService: WordService

    var filteredWords: [Word] {
        if !searchQuery.isEmpty || selectedWordType != nil {
            return wordService.searchWords(query: searchQuery, direction: searchDirection, wordType: selectedWordType)
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

    init() {
        wordService = WordService()
    }
}
