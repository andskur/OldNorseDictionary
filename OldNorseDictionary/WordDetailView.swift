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
        Grid() {
            gridHeader()
            
            Divider()
            
            ForEach(Person.allCases, id: \.rawValue) { person in
                GridRow {
                    Section {
                        Text("\(person.rawValue.capitalized):")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }.frame(width: 100, height: 10).padding(5)
                    
                    ForEach(Number.allCases, id: \.rawValue) { num in
                        verbRow(person: person, num: num)
                    }
                }.padding(5)
                
                Divider()
            }
            
        }.border(.white)
    }
    
    func gridHeader() -> some View {
        GridRow {
            Color.clear.frame(width: 100)
            
            ForEach(Number.allCases, id: \.rawValue) { num in
                if !(word.type != .pronoun && num == .dual) {
                    Section {
                        Text(num.rawValue.capitalized)
                    }.frame(width: 100, height: 10).padding(8)
                }
            }
        }
    }
    
    func verbRow(person: Person, num: Number) -> some View {
        return Section {
            if num != Number.dual {
                if let singularFirstPerson = word.generateConjugation(person: person, number: num) {
                    Text("\(singularFirstPerson)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }.frame(width: 120, height: 10).padding(5)
    }
    
    func nounceRow(c: Case, num: Number) -> some View {
        return Section {
            if !(word.type != .pronoun && num == .dual) {
                if let wordWithCase = word.generateNounCase(nounCase: c, number: num, article: false) {
                    Text("\(wordWithCase)" + withArticle(c: c, num: num)!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }.frame(width: 120, height: 10).padding(5)
    }

    func nounDetailViewContent() -> some View {
        Grid() {
            gridHeader()
            
            Divider()
            
            ForEach(Case.allCases, id: \.rawValue) { c in
                GridRow {
                    Section {
                        Text("\(c.rawValue.capitalized):")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }.frame(width: 100, height: 10).padding(5)
                    
                    ForEach(Number.allCases, id: \.rawValue) { num in
                        nounceRow(c: c,num: num)
                    }
                }.padding(5)
                
                Divider()
            }
        }.border(.white)
    }
    

    
    func withArticle(c: Case, num: Number) -> String? {
        if word.type == .noun {
            if let wordWithCase = word.generateNounCase(nounCase: c, number: num, article: true) {
                return " (\(wordWithCase))"
            }
        }
        
        return ""
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
                
                if word.type == .noun || word.type == .pronoun || word.type == .adjective || word.type == .participle {
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
        let sampleWord = Word(oldNorseWord: "Hús", englishTranslation: "House", russianTranslation: "Дом", definition: "A building for human habitation.", examples: ["Hús er stafrænt orð sem merkir byggingu fyrir mannlega búsetu."], type: .noun, cases: nil, conjugation: nil, verbFirst: nil, verbSecond: nil)
        
        let sampleDirection: SearchDirection = .oldNorseToEnglish
        
        NavigationView {
            WordDetailView(word: sampleWord, searchDirection: sampleDirection)
        }
    }
}


