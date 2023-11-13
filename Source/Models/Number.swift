//
//  Number.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 19.7.23..
//

import Foundation

struct ActiveNumbers: Codable {
    var singular: ActiveGenders? = ActiveGenders.init()
    var dual: ActiveGenders? = nil
    var plural: ActiveGenders? = ActiveGenders.init()
}

enum Number: String, CaseIterable{
    case singular
    case dual
    case plural
}

struct NumberGender: Codable {
    let masculine: String?
    let feminine: String?
    let neuter: String?
    let any: String?
}
