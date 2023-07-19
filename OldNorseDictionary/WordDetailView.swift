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
    
    func verbDetailViewContent() -> some View {
        ForEach(Person.allCases, id: \.rawValue) { person in

            
            ForEach(Number.allCases, id: \.rawValue) { num in
                HStack {
                    verbRow(person: person, num: num)
                }
            }
        }
    }
    
    func verbRow(person: Person, num: Number) -> some View {
        return HStack {
            if num != Number.dual {
                if let singularFirstPerson = word.generateConjugation(person: person, number: num) {
                    Text("\(person.rawValue.capitalized) Person \(num.rawValue.capitalized): \(singularFirstPerson)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    func nounDetailViewContent() -> some View {
        ForEach(Case.allCases, id: \.rawValue) { c in
            Text("\(c.rawValue.capitalized):")
                .font(.subheadline)
                .fontWeight(.bold)
            
            ForEach(Number.allCases, id: \.rawValue) { num in
                HStack {
                    nounceRow(c: c,num: num)
                }
            }
        }
    }

    func nounceRow(c: Case, num: Number) -> some View {
        return HStack {
            if !(word.type != .pronoun && num == .dual) {
                if let wordWithCase = word.generateNounCase(nounCase: c, number: num, article: false) {
                    Text("\(num.rawValue.capitalized): \(wordWithCase)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if word.type == .noun {
                    if let wordWithCase = word.generateNounCase(nounCase: c, number: num, article: true) {
                        Text("(\(wordWithCase))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
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
                    verbDetailViewContent()
                }
                
                if word.type == .noun || word.type == .pronoun{
                    nounDetailViewContent()
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
}

struct WordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleWord = Word(oldNorseWord: "Hús", englishTranslation: "House", russianTranslation: "Дом", definition: "A building for human habitation.", examples: ["Hús er stafrænt orð sem merkir byggingu fyrir mannlega búsetu."], nominative: "Hús", nominativePlural: "Húsar", nominativeDual: nil, accusative: "Hús", accusativePlural: "Húsa", accusativeDual: nil, dative: "Húsi", dativePlural: "Húsum", dativeDual: nil, type: .noun, cases: nil, conjugation: nil, verbFirst: nil, verbSecond: nil)
        
        let sampleDirection: SearchDirection = .oldNorseToEnglish
        
        NavigationView {
            WordDetailView(word: sampleWord, searchDirection: sampleDirection)
        }
    }
}


