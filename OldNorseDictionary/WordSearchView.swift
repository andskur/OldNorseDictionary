//
//  WordSearchView.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 18.7.23..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var controller = WordSearchController()
    
    @State var showingSettings = false
    
    var body: some View {
        VStack {
              Section(
                header: SectionHeader(
                  title: "Settings",
                  isOn: $showingSettings,
                  onLabel: "Hide",
                  offLabel: "Show"
                )
              ) {
                if showingSettings {
                    Form {
                        Picker("Word Type", selection: $controller.selectedWordType) {
                            Text("All").tag(Optional<WordType>(nil))
                            ForEach(WordType.allCases, id: \.self) { wordType in
                                Text(wordType.rawValue.capitalized).tag(Optional(wordType))
                            }
                        }

                        Picker("Search Direction", selection: $controller.searchDirection) {
                            ForEach(SearchDirection.allCases, id: \.self) { direction in
                                Text(searchDiractionDesc(direction: direction)).tag(direction)
                            }
                        }
                    }
                }
              }.padding()
            
            TextField(controller.searchDirection == .englishToOldNorse ? "Enter English word" : "Enter Old Norse word", text: $controller.searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            ScrollView {
                LazyVStack(alignment: .leading) { // Use LazyVStack for improved performance
                    ForEach(controller.filteredWords) { word in
                        WordDetailView(word: word, searchDirection: controller.searchDirection)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            controller.loadWordsData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
