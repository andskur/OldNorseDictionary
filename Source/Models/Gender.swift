//
//  Gender.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 15.9.23..
//

import Foundation

struct ActiveGenders: Codable {
    var masculine: Bool? = true
    var feminine: Bool? = true
    var neuter: Bool? = true
    var any: Bool? = true
    
    func haveGender(gender: Gender) -> Bool {
        switch gender {
        case .masculine:
            if self.masculine == nil {
                return false
            } else {
                return self.masculine!
            }
        case .feminine:
            if self.feminine == nil {
                return false
            } else {
                return self.feminine!
            }
        case .neuter:
            if self.neuter == nil {
                return false
            } else {
                return self.neuter!
            }
        case .any:
            if self.any == nil {
                return false
            } else {
                return self.any!
            }
        }
    }
}

enum Gender: String, CaseIterable{
    case masculine
    case neuter
    case feminine
    case any
}
