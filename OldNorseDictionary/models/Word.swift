//
//  Word.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 18.7.23..
//

import Foundation

enum WordType: String, Codable {
    case noun
    case verb
    case pronoun
    case adverb
    case conjunction
    case interjection
    // Add more word types as needed
}


struct Word: Codable, Identifiable {
    var oldNorseWord: String
    let englishTranslation: String
    let russianTranslation: String
    let definition: String
    let examples: [String]
    let nominative: String? // Optional: Nominative form of the noun/pronoun
    let nominativePlural: String? // Optional: Nominative form pronunciation
    let nominativeDual: String? // Optional: Dual form of the nominative
    let accusative: String? // Optional: Accusative form of the noun/pronoun
    let accusativePlural: String? // Optional: Accusative form pronunciation
    let accusativeDual: String? // Optional: Dual form of the accusative
    let dative: String? // Optional: Dative form of the noun/pronoun
    let dativePlural: String? // Optional: Dative form pronunciation
    let dativeDual: String? // Optional: Dual form of the dative
    let type: WordType // Type of the word (noun, verb, pronoun, etc.)
    let cases: Cases?
    let conjugation: Conjugation?
    let verbFirst: String?
    let verbSecond: String?

    var id: String {
        return oldNorseWord
    }
    
    enum Number {
        case singular
        case dual
        case plural
    }

    
    func neutralNounForm() -> String? {
        var neutralNoun = oldNorseWord
        
        if neutralNoun.last == "r" {
            neutralNoun.removeLast()
        }
        
        return neutralNoun
    }
    
    func generateNounCase(nounCase: Case, number: Number, article: Bool) -> String? {
        switch nounCase {
        case .nominative:
            return generateNominative(number: number, article: article)
        case .accusative:
            return generateAccusative(number: number, article: article)
        case .dative:
            return generateDative(number: number, article: article)
        }
    }
    
    func generateNominative(number: Number, article: Bool) -> String? {
        let nominativeCase = oldNorseWord

        switch number {
        case .singular:
            if let nominativeCaseSingular = cases?.nominative?.singular {
                return nominativeCaseSingular
            }
        case .dual:
            if let nominativeCaseDual = cases?.nominative?.dual {
                return nominativeCaseDual
            }
        case .plural:
            if let nominativeCasePlural = cases?.nominative?.plural {
                return nominativeCasePlural
            }
            
            
            if let neutral = neutralNounForm() {
                return "\(neutral)ar"
            }
        }
        
        return nominativeCase
    }
    
    func generateAccusative(number: Number, article: Bool) -> String? {
        let accusativeCase = neutralNounForm()
        
        switch number {
        case .singular:
            if let accusativeCaseSingular = cases?.accusative?.singular {
                return accusativeCaseSingular
            }
        case .dual:
            if let accusativeCaseDual = cases?.accusative?.dual {
                return accusativeCaseDual
            }
        case .plural:
            if let accusativeCasePlural = cases?.accusative?.plural {
                return accusativeCasePlural
            }
            
            if let neutral = neutralNounForm() {
                return "\(neutral)a"
            }
        }

        return accusativeCase
    }
    
    func generateDative(number: Number, article: Bool) -> String? {
        let dativeCase = neutralNounForm()
        
        switch number {
        case .singular:
            if let dativeCaseSingular = cases?.dative?.singular {
                return dativeCaseSingular
            }
            
            if let neutral = neutralNounForm() {
                return "\(neutral)i"
            }
            
        case .dual:
            if let dativeCaseDual = cases?.dative?.dual {
                return dativeCaseDual
            }
        case .plural:
            if let dativeCasePlural = cases?.dative?.plural {
                return dativeCasePlural
            }
            
            if let neutral = neutralNounForm() {
                return "\(neutral)um"
            }
        }

        return dativeCase
    }
    
    func generateConjugation(person: Person, number: Number) -> String? {
        switch person {
        case .first:
            switch number {
            case .singular:
                if let firstPerson = conjugation?.singular?.firstPerson {
                    return firstPerson
                } else if let verbSecond = verbSecond{
                    return verbSecond
                }
            case .dual, .plural:
                if let firstPerson = conjugation?.plural?.firstPerson {
                    return firstPerson
                } else if let verbFirst = verbFirst{
                    return  (verbFirst.dropLast()) + "um"
                }            }
        case .third:
            switch number {
            case .singular:
                if let thirdPerson = conjugation?.singular?.thirdPerson {
                    return thirdPerson
                }  else if let verbSecond = verbSecond{
                    return verbSecond + "r"
                }
            case .dual, .plural:
                if let thirdPerson = conjugation?.plural?.thirdPerson {
                    return thirdPerson
                } else if let verbFirst = verbFirst{
                    return verbFirst
                }
            }
        }
        
        return ""
    }
    
    func generatePlural(form: Case) -> String? {
        switch form {
        case .nominative:
            if let nominativePlural = nominativePlural {
                return nominativePlural
            } else {
                return generateNominativePlural()
            }
        case .accusative:
            if let accusativePlural = accusativePlural {
                return accusativePlural
            } else {
                return generateAccusativePlural()
            }
        case .dative:
            if let dativePlural = dativePlural {
                return dativePlural
            } else {
                return generateDativePlural()
            }
        }
    }
    
    func generateNominativePlural() -> String? {
        guard let nominative = accusative else {
            return nil
        }
        
        return "\(nominative)ar"
    }
    
    func generateAccusativePlural() -> String? {
        guard let accusative = accusative else {
            return nil
        }
        
        return "\(accusative)a"
    }
    
    func generateDativePlural() -> String? {
        guard let dative = accusative else {
            return nil
        }
        
        return "\(dative)um"
    }
}
