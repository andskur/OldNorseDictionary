//
//  WordTests.swift
//  OldNorseDictionaryTests
//
//  Created by Andrey Skurlatov on 21.7.23..
//

import XCTest
@testable import OldNorseDictionary // Assuming this is the module name where WordSearchController is located

final class WordTests: XCTestCase {

    // Test cases for neutralNounForm method
    func testNeutralNounForm() {
        let word = Word(oldNorseWord: "álfr", englishTranslation: "elf", russianTranslation: "эльф", definition: "A mythical creature in Norse mythology.", examples: [], type: .noun, cases: nil, conjugation: nil, verbFirst: nil, verbSecond: nil)
        
        XCTAssertEqual(word.neutralNounForm(), "álf")
    }

    // Test cases for generateNominative method
    func testGenerateNominative() {
        let word = Word(oldNorseWord: "álfr", englishTranslation: "elf", russianTranslation: "эльф", definition: "A mythical creature in Norse mythology.", examples: [], type: .noun, cases: nil, conjugation: nil, verbFirst: nil, verbSecond: nil)
        
        XCTAssertEqual(word.generateNominative(number: Number.singular, article: false), "álfr")
        XCTAssertEqual(word.generateNominative(number: Number.singular, article: true), "álfrinn")
        XCTAssertEqual(word.generateNominative(number: Number.plural, article: false), "álfar")
        XCTAssertEqual(word.generateNominative(number: Number.plural, article: true), "álfarnir")
    }
    
    // Test cases for generateAccusative method
    func testGenerateAccusative() {
        let word = Word(oldNorseWord: "álfr", englishTranslation: "elf", russianTranslation: "эльф", definition: "A mythical creature in Norse mythology.", examples: [], type: .noun, cases: nil, conjugation: nil, verbFirst: nil, verbSecond: nil)
        
        XCTAssertEqual(word.generateAccusative(number: Number.singular, article: false), "álf")
        XCTAssertEqual(word.generateAccusative(number: Number.singular, article: true), "álfinn")
        XCTAssertEqual(word.generateAccusative(number: Number.plural, article: false), "álfa")
        XCTAssertEqual(word.generateAccusative(number: Number.plural, article: true), "álfana")
    }
    
    // Test cases for generateDative method
    func testGenerateDative() {
        let word = Word(oldNorseWord: "álfr", englishTranslation: "elf", russianTranslation: "эльф", definition: "A mythical creature in Norse mythology.", examples: [], type: .noun, cases: nil, conjugation: nil, verbFirst: nil, verbSecond: nil)
        
        XCTAssertEqual(word.generateDative(number: .singular, article: false), "álfi")
        XCTAssertEqual(word.generateDative(number: .singular, article: true), "álfinum")
        XCTAssertEqual(word.generateDative(number: .plural, article: false), "álfum")
        XCTAssertEqual(word.generateDative(number: .plural, article: true), "álfunum")
    }
    
    // Test cases for generateConjugation method
    func testGenerateConjugation() {
        let word = Word(oldNorseWord: "kenna", englishTranslation: "to know, to recognize", russianTranslation: "знать, узнавать", definition: "To know, to recognize", examples: [], type: .verb, cases: nil, conjugation: nil, verbFirst: "kenna", verbSecond: "kenni")
        
        XCTAssertEqual(word.generateConjugation(person: .first, number: .singular), "kenni")
        XCTAssertEqual(word.generateConjugation(person: .first, number: .plural), "kennum")
        XCTAssertEqual(word.generateConjugation(person: .second, number: .singular), "kennir")
        XCTAssertEqual(word.generateConjugation(person: .second, number: .plural), "kennið")
        XCTAssertEqual(word.generateConjugation(person: .third, number: .singular), "kennir")
        XCTAssertEqual(word.generateConjugation(person: .third, number: .plural), "kenna")
    }

}
