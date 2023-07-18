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
            let nominativeMatchesQuery = word.nominative?.lowercased().contains(lowercaseQuery) == true
            let accusativeMatchesQuery = word.accusative?.lowercased().contains(lowercaseQuery) == true
            let dativeMatchesQuery = word.dative?.lowercased().contains(lowercaseQuery) == true
            let nominativePluralMatchesQuery = word.generatePlural(form: .nominative)?.lowercased().contains(lowercaseQuery) == true
            let accusativePluralMatchesQuery = word.generatePlural(form: .accusative)?.lowercased().contains(lowercaseQuery) == true
            let dativePluralMatchesQuery = word.generatePlural(form: .dative)?.lowercased().contains(lowercaseQuery) == true
            let firstSingularMatchesQuery = word.generateConjugation(person: .first, plural: false)?.lowercased().contains(lowercaseQuery) == true
            let thirdSingularMatchesQuery = word.generateConjugation(person: .third, plural: false)?.lowercased().contains(lowercaseQuery) == true
            let firstPluralMatchesQuery = word.generateConjugation(person: .first, plural: true)?.lowercased().contains(lowercaseQuery) == true
            let thirdPluralMatchesQuery = word.generateConjugation(person: .third, plural: true)?.lowercased().contains(lowercaseQuery) == true
            
            return wordMatchesQuery || nominativeMatchesQuery || accusativeMatchesQuery || dativeMatchesQuery || nominativePluralMatchesQuery || accusativePluralMatchesQuery || dativePluralMatchesQuery || firstSingularMatchesQuery || thirdSingularMatchesQuery || firstPluralMatchesQuery || thirdPluralMatchesQuery
        }
    }
}
