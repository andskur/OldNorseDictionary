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
                if searchDirection == .englishToOldNorse || searchDirection == .oldNorseToEnglish {
                    Text("\(word.oldNorseWord) (\(word.englishTranslation))")
                } else if searchDirection == .russianToOldNorse || searchDirection == .oldNorseToRussian {
                    Text("\(word.oldNorseWord) (\(word.russianTranslation))")
                }
                
                Text(word.type.rawValue.capitalized).italic()

                if word.type == .verb {
                    if let inf = word.generateInfinitive() {
                        Text("Infinitive: at \(inf)")
                    }
                    
                    DynamicTableVerbs(word: word)
                }
                
                if word.generateComparative() != nil {
                    Text("Сomparative: \(word.generateComparative()!)")
                }
                
                
                if word.generateComparison() != nil {
                    Text("Comparison: \(word.generateComparison()!)")
                }
                
                if word.type == .noun || word.type == .pronoun || word.type == .adjective || word.type == .participle {
                    DynamicTable(word: word)
                }

            }
            .padding()
        }
        .navigationTitle(word.oldNorseWord)
    }
}

struct WordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleWord = Word(oldNorseWord: "Hús", base: "huse", declension: nil, englishTranslation: "House", russianTranslation: "Дом", definition: "A building for human habitation.", examples: ["Hús er stafrænt orðn sem merkir byggingu fyrir mannlega búsetu."], type: .noun, cases: nil, gendersCases: nil, numbers: nil, conjugation: nil, subjenctive: nil, verbForms: nil, gender: nil, nounForms: nil, comparative: nil, comparison: nil)
        
        let sampleDirection: SearchDirection = .oldNorseToEnglish
        
        NavigationView {
            WordDetailView(word: sampleWord, searchDirection: sampleDirection)
        }
    }
}


