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
        case oldNorseWord, englishTranslation, russianTranslation, definition, examples, type, cases, gendersCases, numbers, conjugation, verbFirst, verbSecond
    }
    
    var oldNorseWord: String
    let englishTranslation: String
    let russianTranslation: String
    let definition: String
    let examples: [String]
    let type: WordType // Type of the word (noun, verb, pronoun, etc.)
    let cases: Cases?
    let gendersCases: GendersCases?
    var numbers: ActiveNumbers?
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
    
    func countGenders(for number: Number) -> Int {
        var count = 0
        
        switch number {
        case .singular:
            if let sing = numbers?.singular {
                for gen in Gender.allCases {
                    if sing.haveGender(gender: gen) {
                        count += 1
                    }
                }
                return count
            }
        case .dual:
            if let du = numbers?.dual {
                for gen in Gender.allCases {
                    if du.haveGender(gender: gen) {
                        count += 1
                    }
                }
                return count
            }
        case .plural:
            if let plu = numbers?.plural {
                for gen in Gender.allCases {
                    if plu.haveGender(gender: gen) {
                        count += 1
                    }
                }
                return count
            }
        }
        
        return count
    }
    
    
    func hasGenders(number: Number) -> Int {
        if numbers == nil {
            return 0
        }
        
        var count = 0
        
        if (numbers?.singular) != nil {
            count += 1
        }
        
        if (numbers?.dual) != nil {
            count += 1
        }
        
        if (numbers?.plural) != nil {
            count += 1
        }
        
        
        return count
    }
    
    func shouldShowNumber(number: Number) -> Bool {
        if numbers == nil {
            return false
        }
        
        switch number {
        case .singular:
            if let nu = numbers?.singular {
                if nu.feminine == false && nu.masculine == false && nu.neuter == false {
                    return false
                }
                return true
            }
        case .dual:
            if let nu = numbers?.dual {
                if nu.feminine == false && nu.masculine == false && nu.neuter == false {
                    return false
                }
                return true
            }
        case .plural:
            if let nu = numbers?.plural {
                if nu.feminine == false && nu.masculine == false && nu.neuter == false {
                    return false
                }
                return true
            }
        }
        return false
    }
    
    func shouldShowGender(number: Number, gender: Gender) -> Bool {
        if let numb = numbers {
            switch number {
            case .singular:
                if let sing = numb.singular {
                    return sing.haveGender(gender: gender)
                } else {
                    return false
                }
            case .dual:
                if let du = numb.dual {
                    return du.haveGender(gender: gender)
                } else {
                    return false
                }
            case .plural:
                if let plu = numb.plural {
                    return plu.haveGender(gender: gender)
                } else {
                    return false
                }
            }
        } else {
            return false
        }
    }
    
    func generateCase(wordCase: Case, number: Number, gender: Gender) -> String? {
        switch wordCase {
        case .nominative:
            return generateNominative(number: number, gender: gender)
        case .accusative:
            return generateAccusative(number: number, gender: gender)
        case .dative:
            return generateDative(number: number, gender: gender)
        case .genitive:
            return generateGenitive(number: number, gender: gender)
        }
    }
    
    func generateNominative(number: Number, gender: Gender) -> String? {
        var nominativeCase = oldNorseWord

        switch number {
        case .singular:
            switch gender {
            case .masculine:
                if let nominativeCaseSingular = gendersCases?.nominative?.singular?.masculine {
                    nominativeCase = nominativeCaseSingular
                }
            case .feminine:
                if let nominativeCaseSingular = gendersCases?.nominative?.singular?.feminine {
                    nominativeCase = nominativeCaseSingular
                }
            case .neuter:
                if let nominativeCaseSingular = gendersCases?.nominative?.singular?.neuter {
                    nominativeCase = nominativeCaseSingular
                }
            case .any:
                if let nominativeCaseSingular = gendersCases?.nominative?.singular?.any {
                    nominativeCase = nominativeCaseSingular
                }
            }
        case .dual:
            switch gender {
            case .masculine:
                if let nominativeCaseDual = gendersCases?.nominative?.dual?.masculine {
                    nominativeCase = nominativeCaseDual
                }
            case .feminine:
                if let nominativeCaseDual = gendersCases?.nominative?.dual?.feminine {
                    nominativeCase = nominativeCaseDual
                }
            case .neuter:
                if let nominativeCaseDual = gendersCases?.nominative?.dual?.neuter {
                    nominativeCase = nominativeCaseDual
                }
            case .any:
                if let nominativeCaseDual = gendersCases?.nominative?.dual?.any {
                    nominativeCase = nominativeCaseDual
                }
            }
        case .plural:
            switch gender {
            case .masculine:
                if let nominativeCasePlural = gendersCases?.nominative?.plural?.masculine {
                    nominativeCase = nominativeCasePlural
                }
            case .feminine:
                if let nominativeCasePlural = gendersCases?.nominative?.plural?.feminine {
                    nominativeCase = nominativeCasePlural
                }
            case .neuter:
                if let nominativeCasePlural = gendersCases?.nominative?.plural?.neuter {
                    nominativeCase = nominativeCasePlural
                }
            case .any:
                if let nominativeCasePlural = gendersCases?.nominative?.plural?.any {
                    nominativeCase = nominativeCasePlural
                }
            }
        }
        
        return nominativeCase
    }
    
    func generateAccusative(number: Number, gender: Gender) -> String? {
        var accusativeCase = oldNorseWord
        

        switch number {
        case .singular:
            switch gender {
            case .masculine:
                if let accusativeCasePlural = gendersCases?.accusative?.singular?.masculine {
                    accusativeCase = accusativeCasePlural
                }
            case .feminine:
                if let accusativeCasePlural = gendersCases?.accusative?.singular?.feminine {
                    accusativeCase = accusativeCasePlural
                }
            case .neuter:
                if let accusativeCasePlural = gendersCases?.accusative?.singular?.neuter {
                    accusativeCase = accusativeCasePlural
                }
            case .any:
                if let accusativeCasePlural = gendersCases?.accusative?.singular?.any {
                    accusativeCase = accusativeCasePlural
                }
            }
        case .dual:
            switch gender {
            case .masculine:
                if let accusativeCasePlural = gendersCases?.accusative?.dual?.masculine {
                    accusativeCase = accusativeCasePlural
                }
            case .feminine:
                if let accusativeCasePlural = gendersCases?.accusative?.dual?.feminine {
                    accusativeCase = accusativeCasePlural
                }
            case .neuter:
                if let accusativeCasePlural = gendersCases?.accusative?.dual?.neuter {
                    accusativeCase = accusativeCasePlural
                }
            case .any:
                if let accusativeCasePlural = gendersCases?.accusative?.dual?.any {
                    accusativeCase = accusativeCasePlural
                }
            }
        case .plural:
            switch gender {
            case .masculine:
                if let accusativeCasePlural = gendersCases?.accusative?.plural?.masculine {
                    accusativeCase = accusativeCasePlural
                }
            case .feminine:
                if let accusativeCasePlural = gendersCases?.accusative?.plural?.feminine {
                    accusativeCase = accusativeCasePlural
                }
            case .neuter:
                if let accusativeCasePlural = gendersCases?.accusative?.plural?.neuter {
                    accusativeCase = accusativeCasePlural
                }
            case .any:
                if let accusativeCasePlural = gendersCases?.accusative?.plural?.any {
                    accusativeCase = accusativeCasePlural
                }
            }
        }
        
        return accusativeCase
    }
    
    func generateDative(number: Number, gender: Gender) -> String? {
        var dativeCase = oldNorseWord
        

        switch number {
        case .singular:
            switch gender {
            case .masculine:
                if let dativeCaseSingular = gendersCases?.dative?.singular?.masculine {
                    dativeCase = dativeCaseSingular
                }
            case .feminine:
                if let dativeCaseSingular = gendersCases?.dative?.singular?.feminine {
                    dativeCase = dativeCaseSingular
                }
            case .neuter:
                if let dativeCaseSingular = gendersCases?.dative?.singular?.neuter {
                    dativeCase = dativeCaseSingular
                }
            case .any:
                if let dativeCaseSingular = gendersCases?.dative?.singular?.any {
                    dativeCase = dativeCaseSingular
                }
            }
        case .dual:
            switch gender {
            case .masculine:
                if let dativeCaseDual = gendersCases?.dative?.dual?.masculine {
                    dativeCase = dativeCaseDual
                }
            case .feminine:
                if let dativeCaseDual = gendersCases?.dative?.dual?.feminine {
                    dativeCase = dativeCaseDual
                }
            case .neuter:
                if let dativeCaseDual = gendersCases?.dative?.dual?.neuter {
                    dativeCase = dativeCaseDual
                }
            case .any:
                if let dativeCaseDual = gendersCases?.dative?.dual?.any {
                    dativeCase = dativeCaseDual
                }
            }
        case .plural:
            switch gender {
            case .masculine:
                if let dativeCasePlural = gendersCases?.dative?.plural?.masculine {
                    dativeCase = dativeCasePlural
                }
            case .feminine:
                if let dativeCasePlural = gendersCases?.dative?.plural?.feminine {
                    dativeCase = dativeCasePlural
                }
            case .neuter:
                if let dativeCasePlural = gendersCases?.dative?.plural?.neuter {
                    dativeCase = dativeCasePlural
                }
            case .any:
                if let dativeCasePlural = gendersCases?.dative?.plural?.any {
                    dativeCase = dativeCasePlural
                }
            }
        }
        
        return dativeCase
    }
    
    func generateGenitive(number: Number, gender: Gender) -> String? {
        var genitiveCase = oldNorseWord
        

        switch number {
        case .singular:
            switch gender {
            case .masculine:
                if let genitiveCaseSingular = gendersCases?.genitive?.singular?.masculine {
                    genitiveCase = genitiveCaseSingular
                }
            case .feminine:
                if let genitiveCaseSingular = gendersCases?.genitive?.singular?.feminine {
                    genitiveCase = genitiveCaseSingular
                }
            case .neuter:
                if let genitiveCaseSingular = gendersCases?.genitive?.singular?.neuter {
                    genitiveCase = genitiveCaseSingular
                }
            case .any:
                if let genitiveCaseSingular = gendersCases?.genitive?.singular?.any {
                    genitiveCase = genitiveCaseSingular
                }
            }
        case .dual:
            switch gender {
            case .masculine:
                if let genitiveCaseDual = gendersCases?.genitive?.dual?.masculine {
                    genitiveCase = genitiveCaseDual
                }
            case .feminine:
                if let genitiveCaseDual = gendersCases?.genitive?.dual?.feminine {
                    genitiveCase = genitiveCaseDual
                }
            case .neuter:
                if let genitiveCaseDual = gendersCases?.genitive?.dual?.neuter {
                    genitiveCase = genitiveCaseDual
                }
            case .any:
                if let genitiveCaseDual = gendersCases?.genitive?.dual?.any {
                    genitiveCase = genitiveCaseDual
                }
            }
        case .plural:
            switch gender {
            case .masculine:
                if let genitiveCasePlural = gendersCases?.genitive?.plural?.masculine {
                    genitiveCase = genitiveCasePlural
                }
            case .feminine:
                if let genitiveCasePlural = gendersCases?.genitive?.plural?.feminine {
                    genitiveCase = genitiveCasePlural
                }
            case .neuter:
                if let genitiveCasePlural = gendersCases?.genitive?.plural?.neuter {
                    genitiveCase = genitiveCasePlural
                }
            case .any:
                if let genitiveCasePlural = gendersCases?.genitive?.plural?.any {
                    genitiveCase = genitiveCasePlural
                }
            }
        }
        
        return genitiveCase
    }
    
    func generateNounCase(nounCase: Case, number: Number, article: Bool) -> String? {
        switch nounCase {
        case .nominative:
            return generateNounNominative(number: number, article: article)
        case .accusative:
            return generateNounAccusative(number: number, article: article)
        case .dative:
            return generateNounDative(number: number, article: article)
        case .genitive:
            return generateNounGenitive(number: number, article: article)
        }
    }
    
    
    func generateNounNominative(number: Number, article: Bool) -> String? {
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
    
    func generateNounAccusative(number: Number, article: Bool) -> String? {
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
                    } else if oldNorseWord.hasSuffix("inn") {
                        accusativeCase = neutralParticipleForm()! + "inn"
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
    
    func generateNounDative(number: Number, article: Bool) -> String? {
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
    
    func generateNounGenitive(number: Number, article: Bool) -> String? {
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
                if type == WordType.participle {
                    if oldNorseWord.hasSuffix("ðr") {
                        genitiveCase! += "ra"
                    } else if oldNorseWord.hasSuffix("inn") {
                        genitiveCase! += "na"
                    }
                } else if type == WordType.adjective {
                    if oldNorseWord.hasSuffix("ll") {
                        genitiveCase! += "la"
                    } else if oldNorseWord.hasSuffix("nn") {
                        genitiveCase! += "na"
                    } else {
                        genitiveCase! += "ra"
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
                }
            }
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
