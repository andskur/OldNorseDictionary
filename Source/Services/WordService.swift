//
//  WordService.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 30.7.23..
//

import Foundation

// WordService is responsible for loading and filtering the word data
class WordService {
    // The array of Word objects loaded from the WordsData.json file
    var words: [Word] = []

    init() {
        loadWords()
    }

    // This function loads the word data from the WordsData.json file
    func loadWords() {
        guard let fileURL = Bundle.main.url(forResource: "WordsData", withExtension: "json") else {
            fatalError("Failed to locate WordsData.json file.")
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let words = try decoder.decode([Word].self, from: data)
            
            var newWords = [Word]()
            
            for var word in words {
                if word.numbers == nil {
                    word.numbers = ActiveNumbers.init()
                }else {
                    
                    
                    if word.numbers?.singular == nil {
                        word.numbers?.singular = ActiveGenders.init()
                    }
                    
//                    if word.numbers?.dual == nil {
//                        word.numbers?.dual = ActiveGenders.init()
//                    }
                    
                    
                    if word.numbers?.plural == nil {
                        word.numbers?.plural = ActiveGenders.init()
                    }
                    
                }
                
                newWords.append(word)
            }
            
            self.words = newWords // Update the words property
        } catch {
            fatalError("Failed to load WordsData.json: \(error)")
        }
    }

    // This function searches for words based on a search query, a search direction, and a word type
    func searchWords(for searchQuery: String, searchDirection: SearchDirection, wordType: WordType?) -> [Word] {
        let lowercaseQuery = searchQuery.lowercased()
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

        if !searchQuery.isEmpty {
            filteredWords = filterWords(filteredWords, with: lowercaseQuery, searchDirection: searchDirection)
        }
        
        return filteredWords
    }

    // This function filters the words based on a query and a search direction
    func filterWords(_ words: [Word], with query: String, searchDirection: SearchDirection) -> [Word] {
        let lowercaseQuery = query.lowercased()

        return words.filter { word in
            switch searchDirection {
            case .englishToOldNorse:
                return word.englishTranslation.lowercased().contains(lowercaseQuery)
            case .oldNorseToEnglish, .oldNorseToRussian:
                return wordMatchesQuery(word, query: lowercaseQuery)
            case .russianToOldNorse:
                return word.russianTranslation.lowercased().contains(lowercaseQuery)
            }
        }
        .sorted(by: {
            if $1.oldNorseWord.count > $0.oldNorseWord.count {
                return true     
            }
            return false
        })
    }
    
    // This function checks if a word matches a query
    func wordMatchesQuery(_ word: Word, query: String) -> Bool {
        let wordMatchesQuery = word.oldNorseWord.lowercased().contains(query)
        let nominativeSingularMatchesQuery = word.generateNounNominative(number: Number.singular, article: false)?.lowercased().contains(query) == true
        let nominativeDualMatchesQuery = word.generateNounNominative(number: Number.dual, article: false)?.lowercased().contains(query) == true
        let nominativePluralMatchesQuery = word.generateNounNominative(number: Number.plural, article: false)?.lowercased().contains(query) == true
        let accusativeSingularMatchesQuery = word.generateNounAccusative(number: Number.singular, article: false)?.lowercased().contains(query) == true
        let accusativeDualMatchesQuery = word.generateNounAccusative(number: Number.dual, article: false)?.lowercased().contains(query) == true
        let accusativePluralMatchesQuery = word.generateNounAccusative(number: Number.plural, article: false)?.lowercased().contains(query) == true
        let dativeSingularMatchesQuery = word.generateNounDative(number: Number.singular, article: false)?.lowercased().contains(query) == true
        let dativeDualMatchesQuery = word.generateNounDative(number: Number.dual, article: false)?.lowercased().contains(query) == true
        let dativePluralMatchesQuery = word.generateNounDative(number: Number.plural, article: false)?.lowercased().contains(query) == true
        let genitiveSingularMatchesQuery = word.generateNounGenitive(number: Number.singular, article: false)?.lowercased().contains(query) == true
        let genitiveDualMatchesQuery = word.generateNounGenitive(number: Number.dual, article: false)?.lowercased().contains(query) == true
        let genitivePluralMatchesQuery = word.generateNounGenitive(number: Number.plural, article: false)?.lowercased().contains(query) == true
        let firstSingularMatchesQuery = word.generateConjugation(person: .first, number: .singular)?.lowercased().contains(query) == true
        let secondSingularMatchesQuery = word.generateConjugation(person: .second, number: .singular)?.lowercased().contains(query) == true
        let thirdSingularMatchesQuery = word.generateConjugation(person: .third, number: .singular)?.lowercased().contains(query) == true
        let firstPluralMatchesQuery = word.generateConjugation(person: .first, number: .plural)?.lowercased().contains(query) == true
        let secondPluralMatchesQuery = word.generateConjugation(person: .second, number: .plural)?.lowercased().contains(query) == true
        let thirdPluralMatchesQuery = word.generateConjugation(person: .third, number: .plural)?.lowercased().contains(query) == true
        
        // nominative
        let accNominativeSingularMasculine = word.generateCase(wordCase: .nominative, number: .singular, gender: .masculine)?.lowercased().contains(query) == true
        let accNominativeSingularFemenine = word.generateCase(wordCase: .nominative, number: .singular, gender: .feminine)?.lowercased().contains(query) == true
        let accNominativeSingularNeuter = word.generateCase(wordCase: .nominative, number: .singular, gender: .neuter)?.lowercased().contains(query) == true
        
        let accNominativeDualMasculine = word.generateCase(wordCase: .nominative, number: .dual, gender: .masculine)?.lowercased().contains(query) == true
        let accNominativeDualFemenine = word.generateCase(wordCase: .nominative, number: .dual, gender: .feminine)?.lowercased().contains(query) == true
        let accNominativeDualNeuter = word.generateCase(wordCase: .nominative, number: .dual, gender: .neuter)?.lowercased().contains(query) == true
        
        let accNominativePluralMasculine = word.generateCase(wordCase: .nominative, number: .plural, gender: .masculine)?.lowercased().contains(query) == true
        let accNominativePluralFemenine = word.generateCase(wordCase: .nominative, number: .plural, gender: .feminine)?.lowercased().contains(query) == true
        let accNominativePluralNeuter = word.generateCase(wordCase: .nominative, number: .plural, gender: .neuter)?.lowercased().contains(query) == true
        
        
        // accusative
        let accAccusativeSingularMasculine = word.generateCase(wordCase: .accusative, number: .singular, gender: .masculine)?.lowercased().contains(query) == true
        let accAccusativeSingularFemenine = word.generateCase(wordCase: .accusative, number: .singular, gender: .feminine)?.lowercased().contains(query) == true
        let accAccusativeSingularNeuter = word.generateCase(wordCase: .accusative, number: .singular, gender: .neuter)?.lowercased().contains(query) == true
        
        let accAccusativeDualMasculine = word.generateCase(wordCase: .accusative, number: .dual, gender: .masculine)?.lowercased().contains(query) == true
        let accAccusativeDualFemenine = word.generateCase(wordCase: .accusative, number: .dual, gender: .feminine)?.lowercased().contains(query) == true
        let accAccusativeDualNeuter = word.generateCase(wordCase: .accusative, number: .dual, gender: .neuter)?.lowercased().contains(query) == true
        
        let accAccusativePluralMasculine = word.generateCase(wordCase: .accusative, number: .plural, gender: .masculine)?.lowercased().contains(query) == true
        let accAccusativePluralFemenine = word.generateCase(wordCase: .accusative, number: .plural, gender: .feminine)?.lowercased().contains(query) == true
        let accAccusativePluralNeuter = word.generateCase(wordCase: .accusative, number: .plural, gender: .neuter)?.lowercased().contains(query) == true
        
        
        // dative
        let accDativeSingularMasculine = word.generateCase(wordCase: .dative, number: .singular, gender: .masculine)?.lowercased().contains(query) == true
        let accDativeSingularFemenine = word.generateCase(wordCase: .dative, number: .singular, gender: .feminine)?.lowercased().contains(query) == true
        let accDativeSingularNeuter = word.generateCase(wordCase: .dative, number: .singular, gender: .neuter)?.lowercased().contains(query) == true
        
        let accDativeDualMasculine = word.generateCase(wordCase: .dative, number: .dual, gender: .masculine)?.lowercased().contains(query) == true
        let accDativeDualFemenine = word.generateCase(wordCase: .dative, number: .dual, gender: .feminine)?.lowercased().contains(query) == true
        let accDativeDualNeuter = word.generateCase(wordCase: .dative, number: .dual, gender: .neuter)?.lowercased().contains(query) == true
        
        let accDativePluralMasculine = word.generateCase(wordCase: .dative, number: .plural, gender: .masculine)?.lowercased().contains(query) == true
        let accDativePluralFemenine = word.generateCase(wordCase: .dative, number: .plural, gender: .feminine)?.lowercased().contains(query) == true
        let accDativePluralNeuter = word.generateCase(wordCase: .dative, number: .plural, gender: .neuter)?.lowercased().contains(query) == true
        
        // genitive
        let accGenitiveSingularMasculine = word.generateCase(wordCase: .genitive, number: .singular, gender: .masculine)?.lowercased().contains(query) == true
        let accGenitiveSingularFemenine = word.generateCase(wordCase: .genitive, number: .singular, gender: .feminine)?.lowercased().contains(query) == true
        let accGenitiveSingularNeuter = word.generateCase(wordCase: .genitive, number: .singular, gender: .neuter)?.lowercased().contains(query) == true
        
        let accGenitiveDualMasculine = word.generateCase(wordCase: .genitive, number: .dual, gender: .masculine)?.lowercased().contains(query) == true
        let accGenitiveDualFemenine = word.generateCase(wordCase: .genitive, number: .dual, gender: .feminine)?.lowercased().contains(query) == true
        let accGenitiveDualNeuter = word.generateCase(wordCase: .genitive, number: .dual, gender: .neuter)?.lowercased().contains(query) == true
        
        let accGenitivePluralMasculine = word.generateCase(wordCase: .genitive, number: .plural, gender: .masculine)?.lowercased().contains(query) == true
        let accGenitivePluralFemenine = word.generateCase(wordCase: .genitive, number: .plural, gender: .feminine)?.lowercased().contains(query) == true
        let accGenitivePluralNeuter = word.generateCase(wordCase: .genitive, number: .plural, gender: .neuter)?.lowercased().contains(query) == true
        
        let accComparative = word.generateComparative()?.lowercased().contains(query) == true


        return wordMatchesQuery || nominativeSingularMatchesQuery || nominativeDualMatchesQuery || nominativePluralMatchesQuery || accusativeSingularMatchesQuery || accusativeDualMatchesQuery || accusativePluralMatchesQuery || dativeSingularMatchesQuery || dativeDualMatchesQuery || dativePluralMatchesQuery || firstSingularMatchesQuery || secondSingularMatchesQuery || thirdSingularMatchesQuery || firstPluralMatchesQuery || secondPluralMatchesQuery || thirdPluralMatchesQuery || genitiveSingularMatchesQuery || genitiveDualMatchesQuery || genitivePluralMatchesQuery || accNominativeSingularMasculine || accNominativeSingularFemenine || accNominativeSingularNeuter || accNominativeDualMasculine || accNominativeDualFemenine || accNominativeDualNeuter || accNominativePluralMasculine || accNominativePluralFemenine || accAccusativePluralNeuter || accAccusativeSingularMasculine || accAccusativeSingularFemenine || accAccusativeSingularNeuter || accAccusativeDualMasculine || accAccusativeDualFemenine || accAccusativeDualNeuter || accAccusativePluralMasculine || accDativePluralFemenine || accDativePluralNeuter || accGenitiveSingularMasculine || accGenitiveSingularFemenine || accGenitiveSingularNeuter || accGenitiveDualMasculine || accGenitiveDualFemenine || accGenitiveDualNeuter || accGenitivePluralMasculine || accGenitivePluralFemenine || accGenitivePluralNeuter || accNominativePluralNeuter || accDativeSingularMasculine || accDativePluralMasculine || accDativeDualNeuter || accDativeDualFemenine || accDativeDualMasculine || accDativeSingularFemenine || accDativeSingularNeuter || accAccusativePluralFemenine || accComparative
    }
}
