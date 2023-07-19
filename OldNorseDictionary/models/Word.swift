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
    let type: WordType // Type of the word (noun, verb, pronoun, etc.)
    let cases: Cases?
    let conjugation: Conjugation?
    let verbFirst: String?
    let verbSecond: String?

    var id: String {
        return oldNorseWord
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
        var nominativeCase = oldNorseWord

        switch number {
        case .singular:
            if let nominativeCaseSingular = cases?.nominative?.singular {
                nominativeCase = nominativeCaseSingular
            }
            
            if article {
                nominativeCase += "inn"
            }
        case .dual:
            if let nominativeCaseDual = cases?.nominative?.dual {
                return nominativeCaseDual
            }
        case .plural:
            if let nominativeCasePlural = cases?.nominative?.plural {
                nominativeCase = nominativeCasePlural
            } else {
                nominativeCase += "ar"
            }
            
            if article {
                nominativeCase += "inir"
            }
        }
        
        return nominativeCase
    }
    
    func generateAccusative(number: Number, article: Bool) -> String? {
        var accusativeCase = neutralNounForm()
        
        switch number {
        case .singular:
            if let accusativeCaseSingular = cases?.accusative?.singular {
                accusativeCase = accusativeCaseSingular
            }
            
            if article {
                accusativeCase! += "inn"
            }
        case .dual:
            if let accusativeCaseDual = cases?.accusative?.dual {
                return accusativeCaseDual
            }
        case .plural:
            if let accusativeCasePlural = cases?.accusative?.plural {
                accusativeCase = accusativeCasePlural
            } else {
                accusativeCase! += "a"
            }
            
            if article {
                if accusativeCase?.last == "n" {
                    accusativeCase! += "ina"
                } else {
                    accusativeCase! += "na"
                }
            }
        }

        return accusativeCase
    }
    
    func generateDative(number: Number, article: Bool) -> String? {
        var dativeCase = neutralNounForm()
        
        switch number {
        case .singular:
            if let dativeCaseSingular = cases?.dative?.singular {
                dativeCase = dativeCaseSingular
            }
            
            if let neutral = neutralNounForm() {
                dativeCase = "\(neutral)i"
            }
            
            if article {
                dativeCase! += "inum"
            }
            
        case .dual:
            if let dativeCaseDual = cases?.dative?.dual {
                return dativeCaseDual
            }
        case .plural:
            if let dativeCasePlural = cases?.dative?.plural {
                dativeCase = dativeCasePlural
            } else {
                dativeCase! += "um"
            }
            
            if article {
                dativeCase! += "um"
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
}
