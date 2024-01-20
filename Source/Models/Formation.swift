//
//  Formation.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 20.1.24..
//

import Foundation

enum Formation: String, CaseIterable, Codable {
    case strong
    case weak
    case comparative
    case comparisonStrong
    case comparisonWeak
    
    func Title() -> String {
        switch self {
        case .comparisonStrong:
            return "Comparison Strong"
        case .comparisonWeak:
            return "Comparison Weak"
        default:
            return rawValue.capitalized
        }
    }
}
