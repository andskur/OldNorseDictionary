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
    
    
    func verbsMatchesQuery(_ word: Word, query: String) -> Bool {
        let accInfinitive = word.generateInfinitive()?.lowercased().contains(query) == true
        let accImerativeSingular = word.generateImperative(number: .singular)?.lowercased().contains(query) == true
        let accImerativePlural = word.generateImperative(number: .plural)?.lowercased().contains(query) == true
        
        let accImerativeSingularR = word.generateImperativeReflexive(number: .singular)?.lowercased().contains(query) == true
        let accImerativePluralR = word.generateImperativeReflexive(number: .plural)?.lowercased().contains(query) == true
        
        for tense in Tense.allCases {
            for person in Person.allCases {
                for mood in Mood.allCases {
                    for num in Number.allCases {
                        if let w = word.generateConjugation(person: person, number: num, tense: tense, reflexive: true, mood: mood) {
                            if w.lowercased().contains(query) {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        // reflexive
        for tense in Tense.allCases {
            for person in Person.allCases {
                for mood in Mood.allCases {
                    for num in Number.allCases {
                        if let w = word.generateConjugation(person: person, number: num, tense: tense, reflexive: false, mood: mood) {
                            if w.lowercased().contains(query) {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return accInfinitive || accImerativeSingular || accImerativePlural || accImerativeSingularR || accImerativePluralR
    }
    
    func commonMatchesQuery(_ word: Word, query: String) -> Bool {
        for c in Case.allCases {
            for num in Number.allCases {
                for gen in Gender.allCases {
                    if let w = word.generateNounCase(nounCase: c, number: num, article: false) {
                        if w.lowercased().contains(query) {
                            return true
                        }
                    }
                    
                    if let w = word.generateNounCase(nounCase: c, number: num, article: true) {
                        if w.lowercased().contains(query) {
                            return true
                        }
                    }
                    
                    if let w = word.generateCase(wordCase: c, number: num, gender: gen) {
                        if w.lowercased().contains(query) {
                            return true
                        }
                    }
                }
            }
        }

        return false
    }
    
    func adjectivesMatchesQuery(_ word: Word, query: String) -> Bool {
        for f in Formation.allCases {
            for c in Case.allCases {
                for num in Number.allCases {
                    for gen in Gender.allCases {
                        if let w = word.generateAdjective(number: num, gender: gen, caseAdjective: c, formation: f) {
                            if w.lowercased().contains(query) {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func wordMatchesQuery(_ word: Word, query: String) -> Bool {
        let wordMatchesQuery = word.oldNorseWord.lowercased().contains(query)
        let commonMatchesQuery = commonMatchesQuery(word, query: query)
        let verbMatchesQuery = verbsMatchesQuery(word, query: query)
        let adjectivesMatchesQuery = adjectivesMatchesQuery(word, query: query)
        
        return wordMatchesQuery || verbMatchesQuery || commonMatchesQuery || adjectivesMatchesQuery
    }
}
