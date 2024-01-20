//
//  Tense.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 19.12.23..
//

import Foundation

enum Tense: String, CaseIterable, Codable {
    case present
    case past
    
    func Title(reflexive: Bool) -> String {
        var title = self.rawValue.capitalized
        
        if reflexive {
            title = "Reflexive " + title
        }
        
        return title
    }
}
