//
//  Case.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 19.7.23..
//

import Foundation

struct Cases: Codable {
    let nominative: CaseNumber?
    let accusative: CaseNumber?
    let dative: CaseNumber?
    let genitive: CaseNumber?
}

struct CaseNumber: Codable {
    let singular: String?
    let dual: String?
    let plural: String?
}

enum Case: String, CaseIterable {
    case nominative
    case accusative
    case dative
    case genitive
}
