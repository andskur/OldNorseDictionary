//
//  Word.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 18.7.23..
//

import Foundation

enum WordType: String, Codable, CaseIterable {
    case noun
    case verb
    case pronoun
    case adverb
    case conjunction
    case interjection
    case adjective
    case participle
    case preposition
    case phrase
}


struct Word: Codable, Identifiable {
    private enum CodingKeys : String, CodingKey {
        case oldNorseWord, englishTranslation, russianTranslation, definition, examples, type, cases, conjugation, verbFirst, verbSecond
    }
    
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

    var id = UUID()
    
    func neutralNounForm() -> String? {
        var neutralNoun = oldNorseWord
        
        if neutralNoun.last == "r" {
            neutralNoun.removeLast()
        }
        
        if neutralNoun.hasSuffix("ll") {
            neutralNoun.removeLast()
        }
        
        if neutralNoun.hasSuffix("nn") {
            neutralNoun.removeLast()
        }
        
        return neutralNoun
    }
    
    func neutralParticipleForm() -> String? {
        var neutralForm = oldNorseWord
        
        if neutralForm.hasSuffix("inn") {
            neutralForm.removeLast(3)
        } else if neutralForm.hasSuffix("ðr") {
            neutralForm.removeLast()
        }
        
        return neutralForm
    }
    
    func generateNounCase(nounCase: Case, number: Number, article: Bool) -> String? {
        switch nounCase {
        case .nominative:
            return generateNominative(number: number, article: article)
        case .accusative:
            return generateAccusative(number: number, article: article)
        case .dative:
            return generateDative(number: number, article: article)
        case .genitive:
            return generateGenitive(number: number, article: article)
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
                if type == WordType.adjective {
                    nominativeCase = neutralNounForm()! + "ir"
                } else if type == WordType.participle {
                    if oldNorseWord.hasSuffix("inn") {
                        nominativeCase = neutralParticipleForm()! + "nir"
                    } else if oldNorseWord.hasSuffix("ðr") {
                        nominativeCase = neutralParticipleForm()! + "ir"
                    }
                } else {
                    nominativeCase = neutralNounForm()!
                                        
                    if nominativeCase.hasSuffix("inn") {
                        nominativeCase.removeLast(3)
                        nominativeCase += "n"
                    } else if nominativeCase.hasSuffix("in") {
                        nominativeCase.removeLast(2)
                        nominativeCase += "n"
                    }

                    nominativeCase += "ar"
                }
            }
            
            if article {
                if nominativeCase.last == "n" {
                    nominativeCase += "i"
                }
                
                nominativeCase += "nir"
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
            } else {
                if type == WordType.adjective {
                    accusativeCase = neutralNounForm()! + "an"
                } else if type == WordType.participle {
                    if oldNorseWord.hasSuffix("ðr") {
                        accusativeCase = neutralParticipleForm()! + "an"
                    }
                }
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
                if type == WordType.participle {
                    if oldNorseWord.hasSuffix("inn") {
                        accusativeCase = neutralParticipleForm()! + "na"
                    } else if oldNorseWord.hasSuffix("ðr") {
                        accusativeCase = neutralParticipleForm()! + "a"
                    }
                } else {
                    if accusativeCase!.hasSuffix("in") {
                        accusativeCase!.removeLast(2)
                        accusativeCase! += "n"
                    }
                    
                    accusativeCase! += "a"
                }
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
            } else {
                if type == WordType.participle {
                    if oldNorseWord.hasSuffix("inn") {
                        dativeCase = neutralParticipleForm()! + "num"
                    } else if oldNorseWord.hasSuffix("ðr") {
                        dativeCase = neutralParticipleForm()! + "um"
                    }
                } else if type == WordType.adjective {
                    if oldNorseWord.hasSuffix("ll") || oldNorseWord.hasSuffix("nn") {
                        dativeCase! += "um"
                    } else {
                        dativeCase! += "m"
                    }
                } else {
                    if dativeCase!.hasSuffix("in") {
                        dativeCase!.removeLast(2)
                        dativeCase! += "n"
                    }
                    
                    dativeCase! += "i"
                }
            }
        
            if article {
                if dativeCase?.last == "i" {
                    dativeCase?.removeLast()
                }
                
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
                if type == WordType.participle {
                    if oldNorseWord.hasSuffix("inn") {
                        dativeCase = neutralParticipleForm()! + "num"
                    } else if oldNorseWord.hasSuffix("ðr") {
                        dativeCase = neutralParticipleForm()! + "um"
                    }
                } else if type == WordType.adjective {
                    if oldNorseWord.hasSuffix("ll") || oldNorseWord.hasSuffix("nn") {
                        dativeCase! += "um"
                    } else {
                        dativeCase! += "m"
                    }
                }else {
                    if dativeCase!.hasSuffix("in") {
                        dativeCase!.removeLast(2)
                        dativeCase! += "n"
                    }
                    
                    dativeCase! += "um"
                }
            }
            
            if article {
                if dativeCase?.last == "m" {
                    dativeCase?.removeLast()
                    dativeCase! += "n"
                }
                
                dativeCase! += "um"
            }
        }

        return dativeCase
    }
    
    func generateGenitive(number: Number, article: Bool) -> String? {
        var genitiveCase = neutralNounForm()
        
        switch number {
        case .singular:
            if let genitiveCaseSingular = cases?.genitive?.singular {
                genitiveCase = genitiveCaseSingular
            } else {
                if type != WordType.adjective && !oldNorseWord.hasSuffix("inn") {
                    if genitiveCase?.last == "n" {
                        genitiveCase!.removeLast()
                    }
                }
                
                if genitiveCase?.last != "s" {
                    genitiveCase! += "s"
                }
            }
            
            if article {
                genitiveCase! += "ins"
            }
        case .dual:
            if let genitiveCaseDual = cases?.genitive?.dual {
                genitiveCase = genitiveCaseDual
            }
        case .plural:
            if let genitiveCasePlural = cases?.genitive?.plural {
                genitiveCase = genitiveCasePlural
            } else {
                if type == WordType.participle && oldNorseWord.hasSuffix("ðr") {
                    genitiveCase! += "ra"
                } else if type == WordType.adjective {
                    if oldNorseWord.hasSuffix("ll") {
                        genitiveCase! += "la"
                    } else if oldNorseWord.hasSuffix("nn") {
                        genitiveCase! += "na"
                    } else {
                        genitiveCase! += "a"
                    }
                } else {
                    if genitiveCase!.hasSuffix("in") {
                        genitiveCase!.removeLast(2)
                        genitiveCase! += "n"
                    }
                    
                    genitiveCase! += "a"
                }
            }
            
            if article {
                genitiveCase! += "nna"
            }
        }
        
        return genitiveCase
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
        case .second:
            switch number {
            case .singular:
                if let secondPerson = conjugation?.singular?.secondPerson {
                    return secondPerson
                }  else if let verbSecond = verbSecond{
                    return verbSecond + "r"
                }
            case .dual, .plural:
                if let secondPerson = conjugation?.plural?.secondPerson {
                    return secondPerson
                } else if var verbFirst = verbFirst{
                    
                    if verbFirst.last == "a" {
                        verbFirst.removeLast()
                    }
                    
                    if verbFirst.last == "j" || verbFirst.last == "a" {
                        verbFirst.removeLast()
                    }
                    
                    if verbFirst.last != "i" {
                        verbFirst += "i"
                    }
                    
                    return verbFirst + "ð"
                }
            }
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
