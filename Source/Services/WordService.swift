//
//  WordService.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 30.7.23..
//

import Foundation

class WordService {
    var words: [Word] = []

    init() {
        loadWords()
    }

    func loadWords() {
        guard let fileURL = Bundle.main.url(forResource: "WordsData", withExtension: "json") else {
            fatalError("Failed to locate WordsData.json file.")
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let words = try decoder.decode([Word].self, from: data)
            self.words = words // Update the words property
        } catch {
            fatalError("Failed to load WordsData.json: \(error)")
        }
    }

    func searchWords(query: String, direction: SearchDirection, wordType: WordType?) -> [Word] {
        let lowercaseQuery = query.lowercased()
        var filteredWords: [Word] = words

        if wordType != nil {
            filteredWords = filteredWords
                .filter { $0.type == wordType }
                .sorted(by: {
                    if $1.oldNorseWord > $0.oldNorseWord {
                        return true
                    }
                    return false
                })
        }

        if !query.isEmpty {
            switch direction {
            case .englishToOldNorse:
                filteredWords = filteredWords.filter { $0.englishTranslation.lowercased().contains(lowercaseQuery) }
            case .oldNorseToEnglish:
                filteredWords = filterWords(filteredWords, with: lowercaseQuery)
            case .russianToOldNorse:
                filteredWords = filteredWords.filter { $0.russianTranslation.lowercased().contains(lowercaseQuery) }
            case .oldNorseToRussian:
                filteredWords = filterWords(filteredWords, with: lowercaseQuery)
            }
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
        }.sorted(by: {
            if $1.oldNorseWord.count > $0.oldNorseWord.count {
                return true
            }
            
            return false
        })
    }
}
