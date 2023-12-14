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
    case number
}


struct NounForms: Codable {
    let second: String?
    let third: String?
}

struct VerbForms: Codable {
    let infinitive: String?
    let first: String?
    let second: String?
}

struct Word: Codable, Identifiable {
    private enum CodingKeys : String, CodingKey {
        case oldNorseWord, base, declension, englishTranslation, comparative, russianTranslation, definition, examples, type, cases, gendersCases, numbers, conjugation, gender, nounForms, verbForms
    }
    
    var oldNorseWord: String
    let base: String?
    let declension: String?
    let englishTranslation: String
    let russianTranslation: String
    let definition: String
    let examples: [String]
    let type: WordType // Type of the word (noun, verb, pronoun, etc.)
    let cases: Cases?
    let gendersCases: GendersCases?
    var numbers: ActiveNumbers?
    let conjugation: Conjugation?
    
    
    
    let verbForms: VerbForms?
    
//    let verbFirst: String?
//    let verbSecond: String?
    
    
    let gender: Gender?
    
    let nounForms: NounForms?
    
    let comparative: String?
    
    var id = UUID()
    
    func generateInfinitive() -> String? {
        if let inf = verbForms?.infinitive {
            return inf
        }
        
        return oldNorseWord
    }
    
    func neutralNounForm() -> String? {
        if type == .adjective {
            return base
        }
        
        if base != nil {
            return base
        }
        
        switch type {
        case .adjective:
            return base
        case .participle:
            var neutralNoun = oldNorseWord
            
            if neutralNoun.hasSuffix("inn") || neutralNoun.hasSuffix("aðr") {
                neutralNoun.removeLast(3)
            }
            
            return neutralNoun
        default:
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
        if type == .noun {
            return 1
        }
        
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
        if type == .noun {
            return 1
        }
        
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
    
    func shouldShowGender(number: Number, gen: Gender) -> Bool {
        if type == .noun {
            if gender != nil {
                if gender == gen {
                    return true
                } else {
                    return false
                }
            } else {
                if gen == .masculine {
                    return true
                } else {
                    return false
                }
            }
        }
        
        if let numb = numbers {
            switch number {
            case .singular:
                if let sing = numb.singular {
                    return sing.haveGender(gender: gen)
                } else {
                    return false
                }
            case .dual:
                if let du = numb.dual {
                    return du.haveGender(gender: gen)
                } else {
                    return false
                }
            case .plural:
                if let plu = numb.plural {
                    return plu.haveGender(gender: gen)
                } else {
                    return false
                }
            }
        } else {
            return false
        }
    }
    
    func generateComparative() -> String? {
        if comparative != nil {
            return comparative
        }
        return nil
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
                } else {
                    if type == .participle && nominativeCase.hasSuffix("inn") {
                        nominativeCase = neutralNounForm()! + "in"
                    } else if type == .participle && nominativeCase.hasSuffix("aðr") {
                        nominativeCase = neutralNounForm()! + "uð"
                    } else {
                        nominativeCase = neutralNounForm()!
                    }
                }
            case .neuter:
                if let nominativeCaseSingular = gendersCases?.nominative?.singular?.neuter {
                    nominativeCase = nominativeCaseSingular
                } else {
                    switch type {
                    case .adjective,.pronoun,.participle:
                        if oldNorseWord.hasSuffix("ddr") {
                            nominativeCase = neutralNounForm()!
                            nominativeCase.removeLast(2)
                            nominativeCase += "tt"
                        } else if oldNorseWord.hasSuffix("aðr") {
                            nominativeCase = neutralNounForm()!
                            nominativeCase += "at"
                        } else if oldNorseWord.hasSuffix("dr")
                            || oldNorseWord.hasSuffix("ðr")
                            || oldNorseWord.hasSuffix("inn")
                            || oldNorseWord.hasSuffix("tr")
                            || oldNorseWord.hasSuffix("ttr") {
                            
                            let last = nominativeCase.last
                            
                            nominativeCase.removeLast()
                            
                            if nominativeCase.last == last {
                                nominativeCase.removeLast()
                            }
                            
                            if nominativeCase.last != "t" {
                                if nominativeCase.last == "ð" {
                                    nominativeCase.removeLast()
                                    nominativeCase += "t"
                                }
                                nominativeCase += "t"
                            }
                        } else {
                            nominativeCase = neutralNounForm()! + "t"
                        }
                    default:
                        return neutralNounForm()
                    }
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
                } else {
                    if type == .participle && nominativeCase.hasSuffix("inn") {
                        nominativeCase = neutralNounForm()! + "nir"
                    } else if type == .participle && nominativeCase.hasSuffix("aðr") {
                        nominativeCase = neutralNounForm()! + "aðir"
                    } else {
                        nominativeCase = neutralNounForm()! + "ir"
                    }
                }
            case .feminine:
                if let nominativeCasePlural = gendersCases?.nominative?.plural?.feminine {
                    nominativeCase = nominativeCasePlural
                } else {
                    if type == .participle && nominativeCase.hasSuffix("inn") {
                        nominativeCase = neutralNounForm()! + "nar"
                    } else if type == .participle && nominativeCase.hasSuffix("aðr") {
                        nominativeCase = neutralNounForm()! + "aðar"
                    } else {
                        nominativeCase = neutralNounForm()! + "ar"
                    }
                }
            case .neuter:
                if let nominativeCasePlural = gendersCases?.nominative?.plural?.neuter {
                    nominativeCase = nominativeCasePlural
                } else {
                    if type == .participle && nominativeCase.hasSuffix("inn") {
                        nominativeCase = neutralNounForm()! + "in"
                    } else if type == .participle && nominativeCase.hasSuffix("aðr") {
                        nominativeCase = neutralNounForm()! + "uð"
                    } else {
                        nominativeCase = neutralNounForm()!
                    }
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
                } else {
                    if type == .participle && accusativeCase.hasSuffix("inn") {
                        accusativeCase = oldNorseWord
                    } else if type == .participle && accusativeCase.hasSuffix("aðr") {
                        accusativeCase = neutralNounForm()! + "aðan"
                    } else {
                        accusativeCase = neutralNounForm()! + "an"
                    }
                }
            case .feminine:
                if let accusativeCasePlural = gendersCases?.accusative?.singular?.feminine {
                    accusativeCase = accusativeCasePlural
                } else {
                    if type == .participle && accusativeCase.hasSuffix("inn") {
                        accusativeCase = neutralNounForm()! + "na"

                    } else if type == .participle && accusativeCase.hasSuffix("aðr") {
                        accusativeCase = neutralNounForm()! + "aða"
                    } else {
                        accusativeCase = neutralNounForm()! + "a"
                    }
                }
            case .neuter:
                if let accusativeCasePlural = gendersCases?.accusative?.singular?.neuter {
                    accusativeCase = accusativeCasePlural
                } else {
                    switch type {
                    case .adjective,.pronoun,.participle:
                        if oldNorseWord.hasSuffix("ddr") {
                            accusativeCase = neutralNounForm()!
                            accusativeCase.removeLast(2)
                            accusativeCase += "tt"
                        } else if oldNorseWord.hasSuffix("aðr") {
                            accusativeCase = neutralNounForm()!
                            accusativeCase += "at"
                        } else if oldNorseWord.hasSuffix("dr")
                            || oldNorseWord.hasSuffix("ðr")
                            || oldNorseWord.hasSuffix("inn")
                            || oldNorseWord.hasSuffix("tr")
                            || oldNorseWord.hasSuffix("ttr") {
                            
                            let last = accusativeCase.last
                            
                            accusativeCase.removeLast()
                            
                            if accusativeCase.last == last {
                                accusativeCase.removeLast()
                            }
                            
                            if accusativeCase.last != "t" {
                                if accusativeCase.last == "ð" {
                                    accusativeCase.removeLast()
                                    accusativeCase += "t"
                                }
                                accusativeCase += "t"
                            }
                        } else {
                            accusativeCase = neutralNounForm()! + "t"
                        }
                        
                    default:
                        return neutralNounForm()
                    }
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
                } else {
                    if type == .participle && accusativeCase.hasSuffix("inn") {
                        accusativeCase = neutralNounForm()! + "na"
                    } else if type == .participle && accusativeCase.hasSuffix("aðr") {
                        accusativeCase = neutralNounForm()! + "aða"
                    } else {
                        accusativeCase = neutralNounForm()! + "a"
                    }
                }
            case .feminine:
                if let accusativeCasePlural = gendersCases?.accusative?.plural?.feminine {
                    accusativeCase = accusativeCasePlural
                } else {
                    
                    if type == .participle && accusativeCase.hasSuffix("inn") {
                        accusativeCase = neutralNounForm()! + "nar"
                    } else if type == .participle && accusativeCase.hasSuffix("aðr") {
                        accusativeCase = neutralNounForm()! + "aðar"
                    } else {
                        accusativeCase = neutralNounForm()! + "ar"
                    }
                }
            case .neuter:
                if let accusativeCasePlural = gendersCases?.accusative?.plural?.neuter {
                    accusativeCase = accusativeCasePlural
                } else {
                    if type == .participle && accusativeCase.hasSuffix("inn") {
                        accusativeCase = neutralNounForm()! + "in"
                    } else if type == .participle && accusativeCase.hasSuffix("aðr") {
                        accusativeCase = neutralNounForm()! + "uð"
                    } else {
                        accusativeCase = neutralNounForm()!
                    }
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
                } else {
                    if type == .participle && dativeCase.hasSuffix("inn") {
                        dativeCase = neutralNounForm()! + "num"
                    } else if type == .participle && dativeCase.hasSuffix("aðr") {
                        dativeCase = neutralNounForm()! + "uðum"
                    } else {
                        dativeCase = neutralNounForm()! + "um"
                    }
                }
            case .feminine:
                if let dativeCaseSingular = gendersCases?.dative?.singular?.feminine {
                    dativeCase = dativeCaseSingular
                } else {
                    if type == .participle && dativeCase.hasSuffix("inn") {
                        dativeCase = neutralNounForm()! + "inni"
                    } else if type == .participle && dativeCase.hasSuffix("aðr") {
                        dativeCase = neutralNounForm()! + "aðri"
                    } else {
                        if oldNorseWord.hasSuffix("ll") {
                            dativeCase = neutralNounForm()! + "li"
                        } else if oldNorseWord.hasSuffix("nn") {
                            dativeCase = neutralNounForm()! + "ni"
                        } else {
                            dativeCase = neutralNounForm()! + "ri"
                        }
                    }
                }
            case .neuter:
                if let dativeCaseSingular = gendersCases?.dative?.singular?.neuter {
                    dativeCase = dativeCaseSingular
                } else {
                    if type == .participle && dativeCase.hasSuffix("inn") {
                        dativeCase = neutralNounForm()! + "nu"
                    } else if type == .participle && dativeCase.hasSuffix("aðr") {
                        dativeCase = neutralNounForm()! + "uðu"
                    } else {
                        dativeCase = neutralNounForm()! + "u"
                    }
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
                    return dativeCasePlural
                }
            case .feminine:
                if let dativeCasePlural = gendersCases?.dative?.plural?.feminine {
                    return dativeCasePlural
                }
            case .neuter:
                if let dativeCasePlural = gendersCases?.dative?.plural?.neuter {
                    return dativeCasePlural
                }
            case .any:
                if let dativeCasePlural = gendersCases?.dative?.plural?.any {
                    return dativeCasePlural
                }
            }
            
            if type == .participle && dativeCase.hasSuffix("inn") {
                dativeCase = neutralNounForm()! + "num"
            } else if type == .participle && dativeCase.hasSuffix("aðr") {
                dativeCase = neutralNounForm()! + "uðum"
            } else {
                dativeCase = neutralNounForm()! + "um"
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
                } else {
                    if type == .participle && genitiveCase.hasSuffix("inn") {
                        genitiveCase = neutralNounForm()! + "ins"
                    } else if type == .participle && genitiveCase.hasSuffix("aðr") {
                        genitiveCase = neutralNounForm()! + "aðs"
                    } else {
                        genitiveCase = neutralNounForm()! + "s"
                    }
                }
            case .feminine:
                if let genitiveCaseSingular = gendersCases?.genitive?.singular?.feminine {
                    genitiveCase = genitiveCaseSingular
                } else {
                    if type == .participle && genitiveCase.hasSuffix("inn") {
                        genitiveCase = neutralNounForm()! + "innar"
                    } else if type == .participle && genitiveCase.hasSuffix("aðr") {
                        genitiveCase = neutralNounForm()! + "aðrar"
                    } else {
                        genitiveCase = neutralNounForm()! + "ar"
                    }
                }
            case .neuter:
                if let genitiveCaseSingular = gendersCases?.genitive?.singular?.neuter {
                    genitiveCase = genitiveCaseSingular
                } else {
                    if type == .participle && genitiveCase.hasSuffix("inn") {
                        genitiveCase = neutralNounForm()! + "ins"
                    } else if type == .participle && genitiveCase.hasSuffix("aðr") {
                        genitiveCase = neutralNounForm()! + "aðs"
                    } else {
                        genitiveCase = neutralNounForm()! + "s"
                    }
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
                    return genitiveCasePlural
                }
            case .feminine:
                if let genitiveCasePlural = gendersCases?.genitive?.plural?.feminine {
                    return genitiveCasePlural
                }
            case .neuter:
                if let genitiveCasePlural = gendersCases?.genitive?.plural?.neuter {
                    return genitiveCasePlural
                }
            case .any:
                if let genitiveCasePlural = gendersCases?.genitive?.plural?.any {
                    return genitiveCasePlural
                }
            }
            
            if type == .participle && genitiveCase.hasSuffix("inn") {
                genitiveCase = neutralNounForm()! + "inna"
            } else if type == .participle && genitiveCase.hasSuffix("aðr") {
                genitiveCase = neutralNounForm()! + "aðra"
            } else {
                if oldNorseWord.hasSuffix("ll") {
                    genitiveCase = neutralNounForm()! + "la"
                } else if oldNorseWord.hasSuffix("nn") {
                    genitiveCase = neutralNounForm()! + "na"
                } else {
                    genitiveCase = neutralNounForm()! + "ra"
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
                switch gender {
                case .neuter:
                    if nominativeCase.last == "i" {
                        nominativeCase.removeLast()
                    }
                    
                    nominativeCase += "it"
                case .feminine:
                    if nominativeCase.last == "a" {
                        nominativeCase += "n"
                    } else {
                        if  nominativeCase.last == "i" {
                            nominativeCase.removeLast()
                        }
                        nominativeCase += "in"
                    }
                default:
                    nominativeCase += "inn"
                }
                
            }
        case .dual:
            if let nominativeCaseDual = cases?.nominative?.dual {
                return nominativeCaseDual
            }
        case .plural:
            if let nominativeCasePlural = cases?.nominative?.plural {
                nominativeCase = nominativeCasePlural
            } else if let nominativeCasePlural = nounForms?.third {
                nominativeCase = nominativeCasePlural
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
            
            if article {
                switch gender {
                case .neuter:
                    if nominativeCase.last == "i" {
                        nominativeCase.removeLast()
                    }
                    
                    nominativeCase += "in"
                case .feminine:
                    nominativeCase += "nar"
                default:
                    if nominativeCase.last == "n" {
                        nominativeCase += "i"
                    }
                    
                    nominativeCase += "nir"
                }
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
            }
            
            
            switch gender {
            case .feminine:
                if let decl = declension {
                    if decl == "r" {
                        accusativeCase? += "ur"
                    } else if decl == "a" {
                        if accusativeCase!.last == "j" {
                            accusativeCase?.removeLast()
                            accusativeCase! += "i"
                        }
                    }
                } else {
                    if accusativeCase?.last == "a" {
                        accusativeCase?.removeLast()
                        accusativeCase! += "u"
                    }
                }
            case .neuter:
                if accusativeCase?.last == "j" {
                    accusativeCase?.removeLast()
                    accusativeCase! += "i"
                }
            default:
                if let decl = declension {
                    if decl == "i" && accusativeCase?.last == "j" {
                        accusativeCase?.removeLast()
                    } else if decl == "a" && accusativeCase?.last == "j" {
                        accusativeCase?.removeLast()
                        accusativeCase! += "i"
                    }
                }
            }
            
                        
            if article {
                switch gender {
                case .neuter:
                    if accusativeCase?.last == "i" {
                        accusativeCase?.removeLast()
                    }
                    
                    accusativeCase! += "it"
                case .feminine:
                    if accusativeCase!.last == "u" {
                        accusativeCase! += "na"
                    } else {
                        if  accusativeCase!.last == "i" {
                            accusativeCase!.removeLast()
                        }
                        accusativeCase! += "ina"
                    }
                default:
                    if accusativeCase?.last == "i" {
                        accusativeCase?.removeLast()
                    }
                    
                    accusativeCase! += "inn"
                }
            }
        case .dual:
            if let accusativeCaseDual = cases?.accusative?.dual {
                return accusativeCaseDual
            }
        case .plural:
            if let accusativeCasePlural = cases?.accusative?.plural {
                accusativeCase = accusativeCasePlural
            } else {
                switch gender {
                case .neuter, .feminine:
                    if let accusativeCasePlural = nounForms?.third {
                        accusativeCase = accusativeCasePlural
                    }
                default:
                    if let decl = declension {
                        if decl == "i" {
                            if accusativeCase?.last == "j" {
                                accusativeCase?.removeLast()
                            }
                            
                            accusativeCase! += "i"
                        } else if decl == "u" {
                            accusativeCase! += "u"
                        } else if decl == "a" {
                            if  accusativeCase?.last == "j" {
                                accusativeCase?.removeLast()
                            }

                            accusativeCase! += "a"
                        }
                    } else {
                        if accusativeCase!.hasSuffix("in") {
                            accusativeCase!.removeLast(2)
                            accusativeCase! += "n"
                        }
                        
                        accusativeCase! += "a"
                    }
                }
            }
            
            if article {
                switch gender {
                case .neuter:
                    if accusativeCase?.last == "i" {
                        accusativeCase?.removeLast()
                    }
                    
                    accusativeCase! += "in"
                case .feminine:
                    accusativeCase! += "nar"
                default:
                    if accusativeCase?.last == "n" {
                        accusativeCase! += "ina"
                    } else {
                        accusativeCase! += "na"
                    }
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
                switch gender {
                case .feminine:
                    if let decl = declension {
                        if decl == "r" {
                            dativeCase? += "ur"
                        } else if decl == "a" {
                            if dativeCase!.last == "j" {
                                dativeCase?.removeLast()
                                dativeCase! += "i"
                            }
                        }
                    } else {
                        if dativeCase?.last == "a" {
                            dativeCase?.removeLast()
                            dativeCase! += "u"
                        }
                    }
                case .neuter:
                    if dativeCase!.hasSuffix("in") {
                        dativeCase!.removeLast(2)
                        dativeCase! += "n"
                    } else if dativeCase!.last == "j" {
                        dativeCase?.removeLast()
                    }
                    
                    dativeCase! += "i"
                default:
                    if let decl = declension {
                        if decl == "i" {
                            if dativeCase?.last == "j" {
                                dativeCase?.removeLast()
                            } else if dativeCase?.hasSuffix("kk") == false {
                                dativeCase! += "i"
                            }
                        } else if decl == "u" {
                            dativeCase! += "i"
                        } else if decl == "a" && dativeCase?.last == "j" {
                            dativeCase?.removeLast()
                            dativeCase! += "i"
                        } else {
                            dativeCase! += "i"
                        }
                    } else {
                        if dativeCase!.hasSuffix("in") {
                            dativeCase!.removeLast(2)
                            dativeCase! += "n"
                        }
                        
                        dativeCase! += "i"
                    }
                }
            }
        
            if article {
                switch gender {
                case .neuter:
                    if dativeCase?.last == "i" {
                       dativeCase?.removeLast()
                   }
                    
                    dativeCase! += "inu"
                case .feminine:
                    if dativeCase!.last == "u" {
                        dativeCase! += "nni"
                    } else {
                        if  dativeCase!.last == "i" {
                            dativeCase!.removeLast()
                        }
                        dativeCase! += "inni"
                    }
                default:
                    if let decl = declension {
                        if decl == "i" || decl == "u" || decl == "a" {
                            dativeCase! += "num"
                        }
                    } else {
                        if dativeCase?.last == "i" {
                            dativeCase?.removeLast()
                        }
                        
                        dativeCase! += "inum"
                    }
                }
            }
            
        case .dual:
            if let dativeCaseDual = cases?.dative?.dual {
                return dativeCaseDual
            }
        case .plural:
            if let dativeCasePlural = cases?.dative?.plural {
                dativeCase = dativeCasePlural
            } else {
                
                switch gender {
                case .feminine:
                    if let decl = declension {
                        if decl == "r" {
                            dativeCase = nounForms?.third
                            
                            dativeCase! += "um"
                        } else if decl == "a" {
                            if dativeCase?.last == "j" {
                                dativeCase?.removeLast()
                            }
                            dativeCase! += "um"
                        } else {
                            if dativeCase!.hasSuffix("in") {
                                dativeCase!.removeLast(2)
                                dativeCase! += "n"
                            }
                            
                            dativeCase! += "um"
                        }
                    } else {
                        if dativeCase!.hasSuffix("in") {
                            dativeCase!.removeLast(2)
                            dativeCase! += "n"
                        } else if dativeCase!.last == "a" {
                            dativeCase?.removeLast()
                        } else if dativeCase!.last == "i" {
                            dativeCase?.removeLast()
                        }
                        
                        
                        dativeCase! += "um"
                    }
                case .neuter:
                    if dativeCase?.last == "j" {
                        dativeCase?.removeLast()
                    }
                    
                    dativeCase! += "um"
                default:
                    if dativeCase!.hasSuffix("in") {
                        dativeCase!.removeLast(2)
                        dativeCase! += "n"
                    }
                    
                    if let decl = declension {
                        if decl == "i" && dativeCase?.hasSuffix("kk") == true {
                            dativeCase! += "j"
                        } else if decl == "a" && dativeCase?.last == "j" {
                            dativeCase?.removeLast()
                        }
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
            } else if let genitiveCaseSingular = nounForms?.second {
                genitiveCase = genitiveCaseSingular
            } else {
                if genitiveCase?.last == "n" {
                    genitiveCase!.removeLast()
                }
                
                if genitiveCase?.last != "s" {
                    genitiveCase! += "s"
                }
            }
            
            if article {
                switch gender {
                case .feminine:
                    if genitiveCase!.last == "u" {
                        genitiveCase! += "nnar"
                    } else {
                        if  genitiveCase!.last == "i" {
                            genitiveCase!.removeLast()
                        }
                        genitiveCase! += "innar"
                    }
                default:
                    genitiveCase! += "ins"
                }
            }
        case .dual:
            if let genitiveCaseDual = cases?.genitive?.dual {
                genitiveCase = genitiveCaseDual
            }
        case .plural:
            if let genitiveCasePlural = cases?.genitive?.plural {
                genitiveCase = genitiveCasePlural
            } else {

                switch gender {
                case .feminine:
                    if let decl = declension {
                        if decl == "r" {
                            genitiveCase = nounForms?.third
                            
                            genitiveCase! += "a"
                        } else if decl == "a" && genitiveCase!.last == "j" {
                            genitiveCase?.removeLast()
                            genitiveCase! += "a"
                        } else {
                            if genitiveCase!.hasSuffix("in") {
                                genitiveCase!.removeLast(2)
                                genitiveCase! += "n"
                            }
                            
                            genitiveCase! += "a"
                        }
                    } else {
                        if genitiveCase!.hasSuffix("in") {
                            genitiveCase!.removeLast(2)
                            genitiveCase! += "n"
                        } else if genitiveCase!.last == "i" {
                            genitiveCase?.removeLast()
                        }
                        
                        if genitiveCase?.last != "a" {
                            genitiveCase! += "a"
                        }
                    }
                    
                case .neuter:
                    if genitiveCase?.last == "j" {
                        genitiveCase?.removeLast()
                    }
                    genitiveCase! += "a"
                default:
                    if genitiveCase!.hasSuffix("in") {
                        genitiveCase!.removeLast(2)
                        genitiveCase! += "n"
                    }
                    
                    if let decl = declension {
                        if decl == "i" && genitiveCase?.hasSuffix("kk") == true {
                            genitiveCase! += "j"
                        } else if decl == "a" && genitiveCase?.last == "j" {
                            genitiveCase?.removeLast()
                        }
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
    
    
    func generateConjugationNew(person: Person, number: Number) -> String? {
        switch person {
        case .first:
            switch number {
            case .singular:
                if let firstPerson = conjugation?.singular?.firstPerson {
                    return firstPerson
                } else if let verbSecond = verbForms?.second {
                    return verbSecond
                } else {
                    return oldNorseWord
                }
            case .dual, .plural:
                if let firstPerson = conjugation?.plural?.firstPerson {
                    return firstPerson
                } else if let verbFirst = verbForms?.first {
                    return  (verbFirst.dropLast()) + "um"
                } else {
                    return oldNorseWord
                }
            }
        case .second:
            switch number {
            case .singular:
                if let secondPerson = conjugation?.singular?.secondPerson {
                    return secondPerson
                } else if let verbSecond = verbForms?.second {
                    return verbSecond + "r"
                } else {
                    return oldNorseWord
                }
            case .dual, .plural:
                if let secondPerson = conjugation?.plural?.secondPerson {
                    return secondPerson
                } else if var verbFirst = verbForms?.first {

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
                } else {
                    return oldNorseWord
                }
            }
        case .third:
            switch number {
            case .singular:
                if let thirdPerson = conjugation?.singular?.thirdPerson {
                    return thirdPerson
                } else if let verbSecond = verbForms?.second {
                    return verbSecond + "r"
                } else {
                    return oldNorseWord
                }
            case .dual, .plural:
                if let thirdPerson = conjugation?.plural?.thirdPerson {
                    return thirdPerson
                } else if let verbFirst = verbForms?.first {
                    return verbFirst
                } else {
                    return oldNorseWord
                }
            }
        }
    }
    
//    func generateConjugation(person: Person, number: Number) -> String? {
//        switch person {
//        case .first:
//            switch number {
//            case .singular:
//                if let firstPerson = conjugation?.singular?.firstPerson {
//                    return firstPerson
//                } else if let verbSecond = verbSecond{
//                    return verbSecond
//                }
//            case .dual, .plural:
//                if let firstPerson = conjugation?.plural?.firstPerson {
//                    return firstPerson
//                } else if let verbFirst = verbFirst{
//                    return  (verbFirst.dropLast()) + "um"
//                }
//            }
//        case .second:
//            switch number {
//            case .singular:
//                if let secondPerson = conjugation?.singular?.secondPerson {
//                    return secondPerson
//                }  else if let verbSecond = verbSecond{
//                    return verbSecond + "r"
//                }
//            case .dual, .plural:
//                if let secondPerson = conjugation?.plural?.secondPerson {
//                    return secondPerson
//                } else if var verbFirst = verbFirst{
//                    
//                    if verbFirst.last == "a" {
//                        verbFirst.removeLast()
//                    }
//                    
//                    if verbFirst.last == "j" || verbFirst.last == "a" {
//                        verbFirst.removeLast()
//                    }
//                    
//                    if verbFirst.last != "i" {
//                        verbFirst += "i"
//                    }
//                    
//                    return verbFirst + "ð"
//                }
//            }
//        case .third:
//            switch number {
//            case .singular:
//                if let thirdPerson = conjugation?.singular?.thirdPerson {
//                    return thirdPerson
//                }  else if let verbSecond = verbSecond{
//                    return verbSecond + "r"
//                }
//            case .dual, .plural:
//                if let thirdPerson = conjugation?.plural?.thirdPerson {
//                    return thirdPerson
//                } else if let verbFirst = verbFirst{
//                    return verbFirst
//                }
//            }
//        }
//        
//        return ""
//    }
}
