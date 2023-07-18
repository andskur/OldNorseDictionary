//
//  ContentView.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 14.7.23..
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var searchQuery: String = ""
    @State private var searchDirection: SearchDirection = .oldNorseToRussian
    @State private var loadedWords: [Word] = []

    var body: some View {
        VStack {
            Picker("Search Direction", selection: $searchDirection) {
                Text("Old Norse to Russian").tag(SearchDirection.oldNorseToRussian)
                Text("Russian to Old Norse").tag(SearchDirection.russianToOldNorse)
                Text("Old Norse to English").tag(SearchDirection.oldNorseToEnglish)
                Text("English to Old Norse").tag(SearchDirection.englishToOldNorse)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextField(searchDirection == .englishToOldNorse ? "Enter English word" : "Enter Old Norse word", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List {
                ForEach(fetchWordDetails(for: searchQuery, searchDirection: searchDirection)) { word in
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
                }
            }
        }
        .padding()
        .onAppear {
            loadedWords = loadWordsData()
        }
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
    
    func fetchWordDetails(for searchQuery: String, searchDirection: SearchDirection) -> [Word] {
        let lowercaseQuery = searchQuery.lowercased()
        let filteredWords: [Word]
        
        switch searchDirection {
        case .englishToOldNorse:
            filteredWords = loadedWords.filter { $0.englishTranslation.lowercased().contains(lowercaseQuery) }
        case .oldNorseToEnglish:
            filteredWords = loadedWords.filter { word in
                let wordMatchesQuery = word.oldNorseWord.lowercased().contains(lowercaseQuery)
                let nominativeMatchesQuery = word.nominative?.lowercased().contains(lowercaseQuery) == true
                let accusativeMatchesQuery = word.accusative?.lowercased().contains(lowercaseQuery) == true
                let dativeMatchesQuery = word.dative?.lowercased().contains(lowercaseQuery) == true
                let nominativePluralMatchesQuery = word.generatePlural(form: .nominative)?.lowercased().contains(lowercaseQuery) == true
                let accusativePluralMatchesQuery = word.generatePlural(form: .accusative)?.lowercased().contains(lowercaseQuery) == true
                let dativePluralMatchesQuery = word.generatePlural(form: .dative)?.lowercased().contains(lowercaseQuery) == true
                let firstSingularMatchesQuery = word.generateConjugation(person: .first, plural: false)?.lowercased().contains(lowercaseQuery) == true
                let thirdSingularMatchesQuery = word.generateConjugation(person: .third, plural: false)?.lowercased().contains(lowercaseQuery) == true
                let firstPluralMatchesQuery = word.generateConjugation(person: .first, plural: true)?.lowercased().contains(lowercaseQuery) == true
                let thirdPluralMatchesQuery = word.generateConjugation(person: .third, plural: true)?.lowercased().contains(lowercaseQuery) == true
                
                return wordMatchesQuery || nominativeMatchesQuery || accusativeMatchesQuery || dativeMatchesQuery || nominativePluralMatchesQuery || accusativePluralMatchesQuery || dativePluralMatchesQuery || firstSingularMatchesQuery || thirdSingularMatchesQuery || firstPluralMatchesQuery || thirdPluralMatchesQuery
            }
        case .russianToOldNorse:
            filteredWords = loadedWords.filter { $0.russianTranslation.lowercased().contains(lowercaseQuery) }
        case .oldNorseToRussian:
            filteredWords = loadedWords.filter { word in
                let wordMatchesQuery = word.oldNorseWord.lowercased().contains(lowercaseQuery)
                let nominativeMatchesQuery = word.nominative?.lowercased().contains(lowercaseQuery) == true
                let accusativeMatchesQuery = word.accusative?.lowercased().contains(lowercaseQuery) == true
                let dativeMatchesQuery = word.dative?.lowercased().contains(lowercaseQuery) == true
                let nominativePluralMatchesQuery = word.generatePlural(form: .nominative)?.lowercased().contains(lowercaseQuery) == true
                let accusativePluralMatchesQuery = word.generatePlural(form: .accusative)?.lowercased().contains(lowercaseQuery) == true
                let dativePluralMatchesQuery = word.generatePlural(form: .dative)?.lowercased().contains(lowercaseQuery) == true
                let firstSingularMatchesQuery = word.generateConjugation(person: .first, plural: false)?.lowercased().contains(lowercaseQuery) == true
                let thirdSingularMatchesQuery = word.generateConjugation(person: .third, plural: false)?.lowercased().contains(lowercaseQuery) == true
                let firstPluralMatchesQuery = word.generateConjugation(person: .first, plural: true)?.lowercased().contains(lowercaseQuery) == true
                let thirdPluralMatchesQuery = word.generateConjugation(person: .third, plural: true)?.lowercased().contains(lowercaseQuery) == true
                
                return wordMatchesQuery || nominativeMatchesQuery || accusativeMatchesQuery || dativeMatchesQuery || nominativePluralMatchesQuery || accusativePluralMatchesQuery || dativePluralMatchesQuery || firstSingularMatchesQuery || thirdSingularMatchesQuery || firstPluralMatchesQuery || thirdPluralMatchesQuery
            }
        }
        
        return filteredWords
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum SearchDirection {
    case englishToOldNorse
    case oldNorseToEnglish
    case russianToOldNorse
    case oldNorseToRussian
}


func loadWordsData() -> [Word] {
    guard let fileURL = Bundle.main.url(forResource: "WordsData", withExtension: "json") else {
        fatalError("Failed to locate WordsData.json file.")
    }
    
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let words = try decoder.decode([Word].self, from: data)
        return words
    } catch {
        fatalError("Failed to load WordsData.json: \(error)")
    }
}
