//
//  Word.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 18.7.23..
//

import Foundation

enum NounForm: String, Codable {
    case nominative
    case accusative
    case dative
}

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
    let conjugation: Conjugation?
    let verbFirst: String?
    let verbSecond: String?

    var id: String {
        return oldNorseWord
    }
    
    enum Form {
        case nominative
        case accusative
        case dative
    }
    
    enum Person {
        case first
        case third
    }
    
    
    func generateConjugation(person: Person, plural: Bool) -> String? {
        switch person {
        case .first:
            if plural {
                if let firstPerson = conjugation?.plural?.firstPerson {
                    return firstPerson
                } else if let verbFirst = verbFirst{
                    return  (verbFirst.dropLast()) + "um"
                }
            } else {
                if let firstPerson = conjugation?.singular?.firstPerson {
                    return firstPerson
                } else if let verbSecond = verbSecond{
                    return verbSecond
                }
            }
        case .third:
            if plural {
                if let thirdPerson = conjugation?.plural?.thirdPerson {
                    return thirdPerson
                } else if let verbFirst = verbFirst{
                    return verbFirst
                }
            } else {
                if let thirdPerson = conjugation?.singular?.thirdPerson {
                    return thirdPerson
                }  else if let verbSecond = verbSecond{
                    return verbSecond + "r"
                }
            }
        }
        
        return ""
    }
    
    func generatePlural(form: Form) -> String? {
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
