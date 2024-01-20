//
//  Mood.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 20.1.24..
//

import Foundation

enum Mood: String, CaseIterable, Codable {
    case indicative
    case subjunctive
    
    
    func Title(reflexive: Bool) -> String {
        var title = self.rawValue
        
        return title
    }
}
