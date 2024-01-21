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
        // nouns
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
        
        
        // verbs
        let firstSingularMatchesQuery = word.generateConjugationNonReflexive(person: .first, number: .singular, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        let secondSingularMatchesQuery = word.generateConjugationNonReflexive(person: .second, number: .singular, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        let thirdSingularMatchesQuery = word.generateConjugationNonReflexive(person: .third, number: .singular, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        let firstPluralMatchesQuery = word.generateConjugationNonReflexive(person: .first, number: .plural, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        let secondPluralMatchesQuery = word.generateConjugationNonReflexive(person: .second, number: .plural, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        let thirdPluralMatchesQuery = word.generateConjugationNonReflexive(person: .third, number: .plural, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        
        let firstSingularMatchesQueryPast = word.generateConjugationNonReflexive(person: .first, number: .singular, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        let secondSingularMatchesQueryPast = word.generateConjugationNonReflexive(person: .second, number: .singular, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        let thirdSingularMatchesQueryPast = word.generateConjugationNonReflexive(person: .third, number: .singular, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        let firstPluralMatchesQueryPast = word.generateConjugationNonReflexive(person: .first, number: .plural, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        let secondPluralMatchesQueryPast = word.generateConjugationNonReflexive(person: .second, number: .plural, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        let thirdPluralMatchesQueryPast = word.generateConjugationNonReflexive(person: .third, number: .plural, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        
        // reflexive verbs
        let firstSingularMatchesQueryR = word.generateConjugationReflexive(person: .first, number: .singular, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        let secondSingularMatchesQueryR = word.generateConjugationReflexive(person: .second, number: .singular, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        let thirdSingularMatchesQueryR = word.generateConjugationReflexive(person: .third, number: .singular, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        let firstPluralMatchesQueryR = word.generateConjugationReflexive(person: .first, number: .plural, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        let secondPluralMatchesQueryR = word.generateConjugationReflexive(person: .second, number: .plural, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        let thirdPluralMatchesQueryR = word.generateConjugationReflexive(person: .third, number: .plural, tense: .present, mood: .indicative)?.lowercased().contains(query) == true
        
        let firstSingularMatchesQueryPastR = word.generateConjugationReflexive(person: .first, number: .singular, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        let secondSingularMatchesQueryPastR = word.generateConjugationReflexive(person: .second, number: .singular, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        let thirdSingularMatchesQueryPastR = word.generateConjugationReflexive(person: .third, number: .singular, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        let firstPluralMatchesQueryPastR = word.generateConjugationReflexive(person: .first, number: .plural, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        let secondPluralMatchesQueryPastR = word.generateConjugationReflexive(person: .second, number: .plural, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        let thirdPluralMatchesQueryPastR = word.generateConjugationReflexive(person: .third, number: .plural, tense: .past, mood: .indicative)?.lowercased().contains(query) == true
        
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
        let accComparison = word.generateComparison()?.lowercased().contains(query) == true
        
        let accComparativeAdjective1 = word.generateComparativeAdjective(number: .singular, gender: .masculine, caseWeak: .nominative)?.lowercased().contains(query) == true
        let accComparativeAdjective2 = word.generateComparativeAdjective(number: .singular, gender: .neuter, caseWeak: .nominative)?.lowercased().contains(query) == true
        let accComparativeAdjective3 = word.generateComparativeAdjective(number: .plural, gender: .any, caseWeak: .dative)?.lowercased().contains(query) == true
        
        let accComparisonWeakAdjective1 = word.generateComparisonWeakAdjective(number: .singular, gender: .masculine, caseWeak: .nominative)?.lowercased().contains(query) == true
        let accComparisonWeakAdjective2 = word.generateComparisonWeakAdjective(number: .singular, gender: .neuter, caseWeak: .nominative)?.lowercased().contains(query) == true
        let accComparisonWeakAdjective3 = word.generateComparisonWeakAdjective(number: .plural, gender: .any, caseWeak: .dative)?.lowercased().contains(query) == true
        
        let accComparisonStrongAdjective1 = word.generateComparisonStrongAdjective(number: .singular, gender: .masculine, caseStrong: .nominative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective2 = word.generateComparisonStrongAdjective(number: .singular, gender: .neuter, caseStrong: .nominative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective3 = word.generateComparisonStrongAdjective(number: .singular, gender: .feminine, caseStrong: .nominative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective4 = word.generateComparisonStrongAdjective(number: .singular, gender: .masculine, caseStrong: .accusative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective5 = word.generateComparisonStrongAdjective(number: .singular, gender: .feminine, caseStrong: .accusative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective6 = word.generateComparisonStrongAdjective(number: .singular, gender: .masculine, caseStrong: .dative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective7 = word.generateComparisonStrongAdjective(number: .singular, gender: .neuter, caseStrong: .dative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective8 = word.generateComparisonStrongAdjective(number: .singular, gender: .feminine, caseStrong: .dative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective9 = word.generateComparisonStrongAdjective(number: .singular, gender: .masculine, caseStrong: .genitive)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective10 = word.generateComparisonStrongAdjective(number: .singular, gender: .neuter, caseStrong: .genitive)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective11 = word.generateComparisonStrongAdjective(number: .singular, gender: .feminine, caseStrong: .genitive)?.lowercased().contains(query) == true
        
        let accComparisonStrongAdjective12 = word.generateComparisonStrongAdjective(number: .plural, gender: .masculine, caseStrong: .nominative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective13 = word.generateComparisonStrongAdjective(number: .plural, gender: .neuter, caseStrong: .nominative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective14 = word.generateComparisonStrongAdjective(number: .plural, gender: .feminine, caseStrong: .nominative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective15 = word.generateComparisonStrongAdjective(number: .plural, gender: .masculine, caseStrong: .accusative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective16 = word.generateComparisonStrongAdjective(number: .plural, gender: .masculine, caseStrong: .dative)?.lowercased().contains(query) == true
        let accComparisonStrongAdjective17 = word.generateComparisonStrongAdjective(number: .plural, gender: .masculine, caseStrong: .genitive)?.lowercased().contains(query) == true
        
        let accInfinitive = word.generateInfinitive()?.lowercased().contains(query) == true
        let accImerativeSingular = word.generateImperative(number: .singular)?.lowercased().contains(query) == true
        let accImerativePlural = word.generateImperative(number: .plural)?.lowercased().contains(query) == true


        return wordMatchesQuery || nominativeSingularMatchesQuery || nominativeDualMatchesQuery || nominativePluralMatchesQuery || accusativeSingularMatchesQuery || accusativeDualMatchesQuery || accusativePluralMatchesQuery || dativeSingularMatchesQuery || dativeDualMatchesQuery || dativePluralMatchesQuery || firstSingularMatchesQuery || secondSingularMatchesQuery || thirdSingularMatchesQuery || firstPluralMatchesQuery || secondPluralMatchesQuery || thirdPluralMatchesQuery || firstSingularMatchesQueryPast || secondSingularMatchesQueryPast || thirdSingularMatchesQueryPast || firstPluralMatchesQueryPast || secondPluralMatchesQueryPast || thirdPluralMatchesQueryPast || genitiveSingularMatchesQuery || genitiveDualMatchesQuery || genitivePluralMatchesQuery || accNominativeSingularMasculine || accNominativeSingularFemenine || accNominativeSingularNeuter || accNominativeDualMasculine || accNominativeDualFemenine || accNominativeDualNeuter || accNominativePluralMasculine || accNominativePluralFemenine || accAccusativePluralNeuter || accAccusativeSingularMasculine || accAccusativeSingularFemenine || accAccusativeSingularNeuter || accAccusativeDualMasculine || accAccusativeDualFemenine || accAccusativeDualNeuter || accAccusativePluralMasculine || accDativePluralFemenine || accDativePluralNeuter || accGenitiveSingularMasculine || accGenitiveSingularFemenine || accGenitiveSingularNeuter || accGenitiveDualMasculine || accGenitiveDualFemenine || accGenitiveDualNeuter || accGenitivePluralMasculine || accGenitivePluralFemenine || accGenitivePluralNeuter || accNominativePluralNeuter || accDativeSingularMasculine || accDativePluralMasculine || accDativeDualNeuter || accDativeDualFemenine || accDativeDualMasculine || accDativeSingularFemenine || accDativeSingularNeuter || accAccusativePluralFemenine || accComparative || accInfinitive || accImerativeSingular || accImerativePlural || accComparativeAdjective1 || accComparativeAdjective2 || accComparativeAdjective3 || accComparisonWeakAdjective1 || accComparisonWeakAdjective2 || accComparisonWeakAdjective3 || accComparisonStrongAdjective1 || accComparisonStrongAdjective2 || accComparisonStrongAdjective3 || accComparisonStrongAdjective4 || accComparisonStrongAdjective5 || accComparisonStrongAdjective6 || accComparisonStrongAdjective7 || accComparisonStrongAdjective8 || accComparisonStrongAdjective9 || accComparisonStrongAdjective10 || accComparisonStrongAdjective11 || accComparisonStrongAdjective12 || accComparisonStrongAdjective13 || accComparisonStrongAdjective14 || accComparisonStrongAdjective15 || accComparisonStrongAdjective16 || accComparisonStrongAdjective17 || accComparison || firstSingularMatchesQueryR || secondSingularMatchesQueryR || thirdSingularMatchesQueryR || firstPluralMatchesQueryR || secondPluralMatchesQueryR || thirdPluralMatchesQueryR || firstSingularMatchesQueryPastR || secondSingularMatchesQueryPastR || thirdSingularMatchesQueryPastR || firstPluralMatchesQueryPastR || secondPluralMatchesQueryPastR || thirdPluralMatchesQueryPastR
    }
}
