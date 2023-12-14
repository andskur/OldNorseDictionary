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
    
//    func verbDetailViewContent() -> some View {
//        Grid() {
//            verbHeader()
//            
//            Divider()
//            
//            ForEach(Person.allCases, id: \.rawValue) { person in
//                GridRow {
//                    Section {
//                        Text("\(person.rawValue.capitalized):")
//                            .font(.subheadline)
//                            .fontWeight(.bold)
//                    }.frame(height: 10).padding(5)
//                    
//                    ForEach(Number.allCases, id: \.rawValue) { num in
//                        verbRow(person: person, num: num)
//                    }
//                }.padding(5)
//                
//                Divider()
//            }
//            
//        }.border(.white)
//    }
//    
//    func verbHeader() -> some View {
//        GridRow {
//            Text("")
//            
//            ForEach(Number.allCases, id: \.rawValue) { num in
//                if word.shouldShowNumber(number: num) {
//                    Section {
//                        Text(num.rawValue.capitalized)
//                    }.frame(height: 10).padding(8)
//                }
//            }
//        }
//    }
    
    func gridHeader() -> some View {
        GridRow {
//            Color.clear.frame(width: 100)
            
            Text("")
            
            ForEach(Number.allCases, id: \.rawValue) { num in
                if word.shouldShowNumber(number: num) {
                    Section {
                        Text(num.rawValue.capitalized)
                    }.frame(height: 10).padding(8)
                        .gridCellColumns(3)
                }
            }
        }
    }
    
    func genderHeader() -> some View {
        GridRow {
            Color.clear.frame(width: 100)
            
            ForEach(Number.allCases, id: \.rawValue) { num in
                if word.shouldShowNumber(number: num) {
                    ForEach(Gender.allCases, id: \.rawValue) { gen in
                        if word.shouldShowGender(number: num, gen: gen) {
                            Section {
                                Text(gen.rawValue.capitalized)
                            }.frame(height: 10).padding(8)
                        }
                    }
                }
            }
        }
    }
  
//    func verbRow(person: Person, num: Number) -> some View {
//        return Section {
//            if num != Number.dual {
//                if let singularFirstPerson = word.generateConjugation(person: person, number: num) {
//                    Text("\(singularFirstPerson)")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//            }
//        }.frame(height: 10).padding(5)
//    }
    
    func nounceRow(c: Case, num: Number) -> some View {
        return Section {
            if word.shouldShowNumber(number: num) {
                if let wordWithCase = word.generateNounCase(nounCase: c, number: num, article: false) {
                    Text("\(wordWithCase)" + withArticle(c: c, num: num)!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }.frame(height: 10).padding(5)
    }
    

    func nounDetailViewContent() -> some View {
        Grid() {
            gridHeader()
            
            Divider()
            
            genderHeader()
            
            ForEach(Case.allCases, id: \.rawValue) { c in
                GridRow {
                    Section {
                        Text("\(c.rawValue.capitalized):")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }.frame(height: 10).padding(5)
                    
//                    ForEach(Gender.allCases, id: \.rawValue) {g in
//                        ForEach(Number.allCases, id: \.rawValue) { num in
//                            nounceRow(c: c,num: num)
//                        }
//                    }
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
                if searchDirection == .englishToOldNorse || searchDirection == .oldNorseToEnglish {
                    Text("\(word.oldNorseWord) (\(word.englishTranslation))")
                } else if searchDirection == .russianToOldNorse || searchDirection == .oldNorseToRussian {
                    Text("\(word.oldNorseWord) (\(word.russianTranslation))")
                }
                
                Text(word.type.rawValue.capitalized).italic()

                if word.type == .verb {
                    if let inf = word.generateInfinitive() {
                        Text("Infinitive: \(inf)")
                    }
                    
                    DynamicTableVerbs(word: word)
                }
                
                if word.generateComparative() != nil {
                    Text("Сomparative: \(word.generateComparative()!)")
                }
                
                if word.type == .noun || word.type == .pronoun || word.type == .adjective || word.type == .participle {
                    DynamicTable(word: word)
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
        let sampleWord = Word(oldNorseWord: "Hús", base: "huse", declension: nil, englishTranslation: "House", russianTranslation: "Дом", definition: "A building for human habitation.", examples: ["Hús er stafrænt orðn sem merkir byggingu fyrir mannlega búsetu."], type: .noun, cases: nil, gendersCases: nil, numbers: nil, conjugation: nil, verbForms: nil, gender: nil, nounForms: nil, comparative: nil)
        
        let sampleDirection: SearchDirection = .oldNorseToEnglish
        
        NavigationView {
            WordDetailView(word: sampleWord, searchDirection: sampleDirection)
        }
    }
}


