//
//  WordSearchController.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 18.7.23..
//

import Foundation

enum SearchDirection {
    case englishToOldNorse
    case oldNorseToEnglish
    case russianToOldNorse
    case oldNorseToRussian
}

class WordSearchController: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchDirection: SearchDirection = .oldNorseToRussian
    @Published var loadedWords: [Word] = []

    var filteredWords: [Word] {
        fetchWordDetails(for: searchQuery, searchDirection: searchDirection)
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
            let nominativePluralMatchesQuery = word.generateNominative(number: Number.plural, article: false)?.lowercased().contains(lowercaseQuery) == true
            let accusativeSingularMatchesQuery = word.generateAccusative(number: Number.singular, article: false)?.lowercased().contains(lowercaseQuery) == true
            let accusativePluralMatchesQuery = word.generateAccusative(number: Number.plural, article: false)?.lowercased().contains(lowercaseQuery) == true
            let dativeSingularMatchesQuery = word.generateDative(number: Number.singular, article: false)?.lowercased().contains(lowercaseQuery) == true
            let dativePluralMatchesQuery = word.generateDative(number: Number.plural, article: false)?.lowercased().contains(lowercaseQuery) == true
            let firstSingularMatchesQuery = word.generateConjugation(person: .first, number: .singular)?.lowercased().contains(lowercaseQuery) == true
            let thirdSingularMatchesQuery = word.generateConjugation(person: .third, number: .singular)?.lowercased().contains(lowercaseQuery) == true
            let firstPluralMatchesQuery = word.generateConjugation(person: .first, number: .plural)?.lowercased().contains(lowercaseQuery) == true
            let thirdPluralMatchesQuery = word.generateConjugation(person: .third, number: .plural)?.lowercased().contains(lowercaseQuery) == true
            
            return wordMatchesQuery || nominativeSingularMatchesQuery || nominativePluralMatchesQuery || accusativeSingularMatchesQuery || accusativePluralMatchesQuery || dativeSingularMatchesQuery || dativePluralMatchesQuery || firstSingularMatchesQuery || thirdSingularMatchesQuery || firstPluralMatchesQuery || thirdPluralMatchesQuery
        }
    }
}