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
    @Published var loadedWords: [Word] = []

    var filteredWords: [Word] {
        if searchQuery.isEmpty {
            // Show all loaded words when the search query is empty
            return loadedWords
        } else {
            return fetchWordDetails(for: searchQuery, searchDirection: searchDirection)
        }
    }
    
    init() {
        loadWordsData()
    }
    
    func loadWordsData() {
        guard let fileURL = Bundle.main.url(forResource: "WordsData", withExtension: "json") else {
            fatalError("Failed to locate WordsData.json file.")
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let words = try decoder.decode([Word].self, from: data)
            loadedWords = words // Update the loadedWords property
        } catch {
            fatalError("Failed to load WordsData.json: \(error)")
        }
    }
    
    func fetchWordDetails(for searchQuery: String, searchDirection: SearchDirection) -> [Word] {
        let lowercaseQuery = searchQuery.lowercased()
        let filteredWords: [Word]
        
        switch searchDirection {
        case .englishToOldNorse:
            filteredWords = loadedWords.filter { $0.englishTranslation.lowercased().contains(lowercaseQuery) }
        case .oldNorseToEnglish:
            filteredWords = filterWords(loadedWords, with: lowercaseQuery)
        case .russianToOldNorse:
            filteredWords = loadedWords.filter { $0.russianTranslation.lowercased().contains(lowercaseQuery) }
        case .oldNorseToRussian:
            filteredWords = filterWords(loadedWords, with: lowercaseQuery)
        }
        
        return filteredWords
    }
    
    func filterWords(_ words: [Word], with query: String) -> [Word] {
        let lowercaseQuery = query.lowercased()
        return words.filter { word in
            let wordMatchesQuery = word.oldNorseWord.lowercased().contains(lowercaseQuery)
            let nominativeSingularMatchesQuery = word.generateNominative(number: Number.singular, article: false)?.lowercased().contains(lowercaseQuery) == true
            let nominativeDualMatchesQuery = word.generateNominative(number: Number.dual, article: false)?.lowercased().contains(lowercaseQuery) == true
            let nominativePluralMatchesQuery = word.generateNominative(number: Number.plural, article: false)?.lowercased().contains(lowercaseQuery) == true
            let accusativeSingularMatchesQuery = word.generateAccusative(number: Number.singular, article: false)?.lowercased().contains(lowercaseQuery) == true
            let accusativeDualMatchesQuery = word.generateAccusative(number: Number.dual, article: false)?.lowercased().contains(lowercaseQuery) == true
            let accusativePluralMatchesQuery = word.generateAccusative(number: Number.plural, article: false)?.lowercased().contains(lowercaseQuery) == true
            let dativeSingularMatchesQuery = word.generateDative(number: Number.singular, article: false)?.lowercased().contains(lowercaseQuery) == true
            let dativeDualMatchesQuery = word.generateDative(number: Number.dual, article: false)?.lowercased().contains(lowercaseQuery) == true
            let dativePluralMatchesQuery = word.generateDative(number: Number.plural, article: false)?.lowercased().contains(lowercaseQuery) == true
            let firstSingularMatchesQuery = word.generateConjugation(person: .first, number: .singular)?.lowercased().contains(lowercaseQuery) == true
            let secondSingularMatchesQuery = word.generateConjugation(person: .second, number: .singular)?.lowercased().contains(lowercaseQuery) == true
            let thirdSingularMatchesQuery = word.generateConjugation(person: .third, number: .singular)?.lowercased().contains(lowercaseQuery) == true
            let firstPluralMatchesQuery = word.generateConjugation(person: .first, number: .plural)?.lowercased().contains(lowercaseQuery) == true
            let secondPluralMatchesQuery = word.generateConjugation(person: .second, number: .plural)?.lowercased().contains(lowercaseQuery) == true
            let thirdPluralMatchesQuery = word.generateConjugation(person: .third, number: .plural)?.lowercased().contains(lowercaseQuery) == true
            
            return wordMatchesQuery || nominativeSingularMatchesQuery || nominativeDualMatchesQuery || nominativePluralMatchesQuery || accusativeSingularMatchesQuery || accusativeDualMatchesQuery || accusativePluralMatchesQuery || dativeSingularMatchesQuery || dativeDualMatchesQuery || dativePluralMatchesQuery || firstSingularMatchesQuery || secondSingularMatchesQuery || thirdSingularMatchesQuery || firstPluralMatchesQuery || secondPluralMatchesQuery || thirdPluralMatchesQuery
        }
    }
}
