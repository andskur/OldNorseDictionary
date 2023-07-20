//
//  WordSearchView.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 18.7.23..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var controller = WordSearchController()
    
    var body: some View {
        VStack {
            Picker("Search Direction", selection: $controller.searchDirection) {
                ForEach(SearchDirection.allCases, id: \.rawValue) { direction in
                    Text(searchDiractionDesc(direction: direction)).tag(direction)
                }
            }
            
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
