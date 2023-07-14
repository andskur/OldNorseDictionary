//
//  ContentView.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 14.7.23..
//

import SwiftUI
import Foundation

enum NounForm: String, Codable {
    case nominative
    case accusative
    case dative
}

enum WordType: String, Codable {
    case noun
    case verb
    case pronoun
    // Add more word types as needed
}

struct Word: Codable, Identifiable {
    let oldNorseWord: String
    let englishTranslation: String
    let russianTranslation: String
    let definition: String
    let examples: [String]
    let nominative: String? // Optional: Nominative form of the noun
    let accusative: String? // Optional: Accusative form of the noun
    let dative: String? // Optional: Dative form of the noun
    let type: WordType // Type of the word (noun, verb, etc.)
    
    var id: String {
        return oldNorseWord
    }
    
    
    enum Form {
        case nominative
        case accusative
        case dative
    }
}

struct ContentView: View {
    @State private var searchQuery: String = ""
    @State private var searchDirection: SearchDirection = .englishToOldNorse
    @State private var loadedWords: [Word] = []

    var body: some View {
        VStack {
            Picker("Search Direction", selection: $searchDirection) {
                Text("English to Old Norse").tag(SearchDirection.englishToOldNorse)
                Text("Old Norse to English").tag(SearchDirection.oldNorseToEnglish)
                Text("Russian to Old Norse").tag(SearchDirection.russianToOldNorse)
                Text("Old Norse to Russian").tag(SearchDirection.oldNorseToRussian)
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
                        
                        if let nominative = word.nominative {
                            Text("Nominative: \(nominative) (\(wordWithArticle(nominative, form: .nominative)))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                        
                        if let accusative = word.accusative {
                            Text("Accusative: \(accusative) (\(wordWithArticle(accusative, form: .accusative)))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                        
                        if let dative = word.dative {
                            Text("Dative: \(dative) (\(wordWithArticle(dative, form: .dative)))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                        
                        Text(word.definition)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
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
    
    func wordWithArticle(_ word: String, form: NounForm) -> String {
        let article: String
        
        switch form {
        case .nominative, .accusative:
            article = "inn"
        case .dative:
            article = "inum"
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
                
                return wordMatchesQuery || nominativeMatchesQuery || accusativeMatchesQuery || dativeMatchesQuery
            }
        case .russianToOldNorse:
            filteredWords = loadedWords.filter { $0.russianTranslation.lowercased().contains(lowercaseQuery) }
        case .oldNorseToRussian:
            filteredWords = loadedWords.filter { word in
                let wordMatchesQuery = word.oldNorseWord.lowercased().contains(lowercaseQuery)
                let nominativeMatchesQuery = word.nominative?.lowercased().contains(lowercaseQuery) == true
                let accusativeMatchesQuery = word.accusative?.lowercased().contains(lowercaseQuery) == true
                let dativeMatchesQuery = word.dative?.lowercased().contains(lowercaseQuery) == true
                
                return wordMatchesQuery || nominativeMatchesQuery || accusativeMatchesQuery || dativeMatchesQuery
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
