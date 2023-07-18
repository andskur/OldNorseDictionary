//
//  Conjugation.swift
//  OldNorseDictionary
//
//  Created by Andrey Skurlatov on 18.7.23..
//

import Foundation

struct Conjugation: Codable {
    let singular: Persons?
    let plural: Persons?
 }


struct Persons: Codable {
    let firstPerson: String?
    let secondPerson: String?
    let thirdPerson: String?
}
