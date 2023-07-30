//
//  WordListView.swift
//  OldNorseDictionaryWatchOs Watch App
//
//  Created by Andrey Skurlatov on 29.7.23..
//

import SwiftUI

struct WordListView: View {
    @StateObject var controller = WordSearchController()
    @State private var isPresentingModalView = false
    
    var settings: some View {
        Group {
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
            .padding()
            
         }
        .opacity(0.8)
        .padding(10)
    }

    var body: some View {
        ScrollViewReader {value in
            ScrollView {
                Button(action: {isPresentingModalView.toggle() }, label: {
                    Text("Settings")
                    Image(systemName: "gear")
                })
                .fullScreenCover(isPresented: $isPresentingModalView) {
                    settings
                }
                
                Spacer()
                Spacer()
                
                LazyVStack(alignment: .leading) { // Use LazyVStack for improved performance
                    ForEach(controller.filteredWords) { word in
                        Group {
                            Text(word.oldNorseWord)
                                .font(.headline)
                            
                            if controller.searchDirection == .englishToOldNorse || controller.searchDirection == .oldNorseToEnglish {
                                Text(word.englishTranslation)
                                    .font(.subheadline)
                            } else if controller.searchDirection == .russianToOldNorse || controller.searchDirection == .oldNorseToRussian {
                                Text(word.russianTranslation)
                                    .font(.subheadline)
                            }

                            Divider()
                        }
                        .padding()
                        .font(.system(size: 60))
                    }
                    .navigationTitle("Words")
                }
            }
            .onAppear {
                value.scrollTo(controller.filteredWords[0].id, anchor: .top)
            }
        }
    }
}

struct WordListView_Previews: PreviewProvider {
    static var previews: some View {
        WordListView()
    }
}
