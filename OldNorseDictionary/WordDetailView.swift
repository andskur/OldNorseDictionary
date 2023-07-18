//
//  WordDetailView.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 18.7.23..
//

import SwiftUI

struct WordDetailView: View {
    let word: Word
    let searchDirection: SearchDirection
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if searchDirection == .englishToOldNorse {
                    Text("\(word.oldNorseWord) (\(word.englishTranslation))")
                } else if searchDirection == .oldNorseToEnglish {
                    Text("\(word.englishTranslation) (\(word.oldNorseWord))")
                } else if searchDirection == .russianToOldNorse {
                    Text("\(word.oldNorseWord) (\(word.russianTranslation))")
                } else if searchDirection == .oldNorseToRussian {
                    Text("\(word.russianTranslation) (\(word.oldNorseWord))")
                }
                
                if word.type == .verb {
                    if let singularFirstPerson = word.generateConjugation(person: .first, plural: false) {
                        Text("First Person Singular: \(singularFirstPerson)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let pluralFirstPerson = word.generateConjugation(person: .first, plural: true) {
                        Text("First Person Plural: \(pluralFirstPerson)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let singularThirdPerson = word.generateConjugation(person: .third, plural: false) {
                        Text("Third Person Singular: \(singularThirdPerson)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let pluralThirdPerson = word.generateConjugation(person: .third, plural: true) {
                        Text("Third Person Plural: \(pluralThirdPerson)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let nominative = word.nominative {
                    Text("Nominative:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Text("Singular: \(nominative)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    
                    if word.type == .noun {
                        let singularArticle = wordWithArticle(nominative, form: .nominative, plural: false)
                        Text("Singular with Article: \(singularArticle)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let nominativeDual = word.nominativeDual {
                        Text("Dual: \(nominativeDual)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let nominativePlural = word.generatePlural(form: .nominative) {
                        Text("Plural: \(nominativePlural)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if word.type == .noun {
                            let pluralArticle = wordWithArticle(nominativePlural, form: .nominative, plural: true)
                            Text("Plural with Article: \(pluralArticle)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if let accusative = word.accusative {
                    Text("Accusative:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Text("Singular: \(accusative)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if word.type == .noun {
                        let singularArticle = wordWithArticle(accusative, form: .nominative, plural: false)
                        Text("Singular with Article: \(singularArticle)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let accusativeDual = word.accusativeDual {
                        Text("Dual: \(accusativeDual)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let accusativePlural = word.generatePlural(form: .accusative) {
                        Text("Plural: \(accusativePlural)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if word.type == .noun {
                            let pluralArticle = wordWithArticle(accusativePlural, form: .accusative, plural: true)
                            Text("Plural with Article: \(pluralArticle)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if let dative = word.dative {
                    Text("Dative:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Text("Singular: \(dative)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if word.type == .noun {
                        let singularArticle = wordWithArticle(dative, form: .dative, plural: false)
                        Text("Singular with Article: \(singularArticle)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let dativeDual = word.dativeDual {
                        Text("Dual: \(dativeDual)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let dativePlural = word.generatePlural(form: .dative) {
                        Text("Plural: \(dativePlural)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if word.type == .noun {
                            let pluralArticle = wordWithArticle(dativePlural, form: .dative, plural: true)
                            Text("Plural with Article: \(pluralArticle)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
//                        Text(word.definition)
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
// Additional view components for examples, pronunciation, etc.
            }
            .padding()
        }
        .navigationTitle(word.oldNorseWord)
    }
    
    func wordWithArticle(_ word: String, form: NounForm, plural: Bool) -> String {
        let article: String
        
        switch form {
        case .nominative:
            if plural {
                article = "inir"
            } else {
                article = "inn"
            }
        case .accusative:
            if plural {
                article = "ina"
            } else {
                article = "inn"
            }
        case .dative:
            if plural {
                article = "um"
            } else {
                article = "inum"
            }
        }
        
        return "\(word)\(article)"
    }
}

struct WordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleWord = Word(oldNorseWord: "Hús", englishTranslation: "House", russianTranslation: "Дом", definition: "A building for human habitation.", examples: ["Hús er stafrænt orð sem merkir byggingu fyrir mannlega búsetu."], nominative: "Hús", nominativePlural: "Húsar", nominativeDual: nil, accusative: "Hús", accusativePlural: "Húsa", accusativeDual: nil, dative: "Húsi", dativePlural: "Húsum", dativeDual: nil, type: .noun, conjugation: nil, verbFirst: nil, verbSecond: nil)
        
        let sampleDirection: SearchDirection = .oldNorseToEnglish
        
        NavigationView {
            WordDetailView(word: sampleWord, searchDirection: sampleDirection)
        }
    }
}


