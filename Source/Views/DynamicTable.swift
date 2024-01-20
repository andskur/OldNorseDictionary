import SwiftUI

struct DynamicTable: View {
    let word: Word
    
    
    func Headers() -> some View {
        Group {
            HStack(spacing: 0) {
                Text("")
                    .frame(minWidth: 87, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .border(Color.black, width: 1)
                
                ForEach(Number.allCases, id: \.rawValue) { num in
                    if word.shouldShowNumber(number: num) {
                        let headerWidthValue = headerWidth(for: num)
                        Text(num.rawValue.capitalized)
                            .frame(minWidth: headerWidthValue, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                    }
                }
            }
            
            HStack(spacing: 0) {
                Text("")
                    .frame(minWidth: 87, maxWidth: 87)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .border(Color.black, width: 1)
                
                ForEach(Number.allCases, id: \.rawValue) { num in
                    if word.shouldShowNumber(number: num) {
                        ForEach(Gender.allCases, id: \.rawValue) { gen in
                            if word.shouldShowGender(number: num, gen: gen) {
                                Text(gen.rawValue.capitalized)
                                    .frame(minWidth: calcWidth(), maxWidth: calcWidth())
                                    .padding(.vertical, 10)
                                    .background(Color.gray.opacity(0.2))
                                    .border(Color.black, width: 1)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack(alignment: .leading) {
                if word.type == .adjective {
                    HStack(spacing: 0) {
                        Text("")
                            .frame(minWidth: 87, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                        
                        Text("Strong Inflection")
                            .frame(minWidth: 522, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                    }
                }
                
                Headers()
                
                // Rows
                ForEach(Case.allCases, id: \.rawValue) { c in
                    HStack(spacing: 0) {
                        Text(c.rawValue.capitalized)
                            .frame(minWidth: 87, maxWidth: 87)
                            .padding(.vertical, 10)
                            .border(Color.black, width: 1)
                            .background(Color.gray.opacity(0.2))
                        
                        ForEach(Number.allCases, id: \.rawValue) { num in
                            if word.shouldShowNumber(number: num) {
                                ForEach(Gender.allCases, id: \.rawValue) { gen in
                                    if word.shouldShowGender(number: num, gen: gen) {
                                        if word.type == .noun {
                                            if let wordWithCase = word.generateNounCase(nounCase: c, number: num, article: false) {
                                                Text("\(wordWithCase)" + withArticle(c: c, num: num)!)
                                                    .frame(minWidth: calcWidth(), maxWidth: calcWidth())
                                                    .padding(.vertical, 10)
                                                    .border(Color.black, width: 1)
                                            }
                                        } else {
                                            if let wordWithCase = word.generateCase(wordCase: c, number: num, gender: gen) {
                                                Text(wordWithCase)
                                                    .frame(minWidth: calcWidth(), maxWidth: calcWidth())
                                                    .padding(.vertical, 10)
                                                    .border(Color.black, width: 1)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if word.type == .adjective {
                    HStack(spacing: 0) {
                        Text("")
                            .frame(minWidth: 87, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                        
                        Text("Weak Inflection")
                            .frame(minWidth: 522, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                    }
                    
                    // Main Headers
                    Headers()
                    
                    // Rows
                    ForEach(Case.allCases, id: \.rawValue) { c in
                        HStack(spacing: 0) {
                            Text(c.rawValue.capitalized)
                                .frame(minWidth: 87, maxWidth: 87)
                                .padding(.vertical, 10)
                                .border(Color.black, width: 1)
                                .background(Color.gray.opacity(0.2))
                            
                            ForEach(Number.allCases, id: \.rawValue) { num in
                                if num == .plural {
                                    if let weakAdjective = word.generateWeakAdjective(number: num, gender: .any, caseWeak: c) {
                                        Text(weakAdjective)
                                            .frame(minWidth: 261, maxWidth: 261)
                                            .padding(.vertical, 10)
                                            .border(Color.black, width: 1)
                                    }
                                } else {
                                    if word.shouldShowNumber(number: num) {
                                        ForEach(Gender.allCases, id: \.rawValue) { gen in
                                            if word.shouldShowGender(number: num, gen: gen) {
                                                if let weakAdjective = word.generateWeakAdjective(number: num, gender: gen, caseWeak: c) {
                                                    Text(weakAdjective)
                                                        .frame(minWidth: calcWidth(), maxWidth: calcWidth())
                                                        .padding(.vertical, 10)
                                                        .border(Color.black, width: 1)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 0) {
                        Text("")
                            .frame(minWidth: 87, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                        
                        Text("Comparative")
                            .frame(minWidth: 522, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                    }
                    
                    // Main Headers
                    Headers()

                    // Rows
                    ForEach(Case.allCases, id: \.rawValue) { c in
                        HStack(spacing: 0) {
                            Text(c.rawValue.capitalized)
                                .frame(minWidth: 87, maxWidth: 87)
                                .padding(.vertical, 10)
                                .border(Color.black, width: 1)
                                .background(Color.gray.opacity(0.2))
                            
                            ForEach(Number.allCases, id: \.rawValue) { num in
                                if num == .plural {
                                    if let weakAdjective = word.generateComparativeAdjective(number: num, gender: .any, caseWeak: c) {
                                        Text(weakAdjective)
                                            .frame(minWidth: 261, maxWidth: 261)
                                            .padding(.vertical, 10)
                                            .border(Color.black, width: 1)
                                    }
                                } else {
                                    if word.shouldShowNumber(number: num) {
                                        ForEach(Gender.allCases, id: \.rawValue) { gen in
                                            if word.shouldShowGender(number: num, gen: gen) {
                                                if let weakAdjective = word.generateComparativeAdjective(number: num, gender: gen, caseWeak: c) {
                                                    Text(weakAdjective)
                                                        .frame(minWidth: calcWidth(), maxWidth: calcWidth())
                                                        .padding(.vertical, 10)
                                                        .border(Color.black, width: 1)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 0) {
                        Text("")
                            .frame(minWidth: 87, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                        
                        Text("Comparison Strong")
                            .frame(minWidth: 522, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                    }
                    
                    // Main Headers
                    Headers()
                    
                    // Rows
                    ForEach(Case.allCases, id: \.rawValue) { c in
                        HStack(spacing: 0) {
                            Text(c.rawValue.capitalized)
                                .frame(minWidth: 87, maxWidth: 87)
                                .padding(.vertical, 10)
                                .border(Color.black, width: 1)
                                .background(Color.gray.opacity(0.2))
                            
                            ForEach(Number.allCases, id: \.rawValue) { num in
                                if word.shouldShowNumber(number: num) {
                                    ForEach(Gender.allCases, id: \.rawValue) { gen in
                                        if word.shouldShowGender(number: num, gen: gen) {
                                            if let wordWithCase = word.generateComparisonStrongAdjective(number: num, gender: gen, caseStrong: c) {
                                                Text(wordWithCase)
                                                    .frame(minWidth: calcWidth(), maxWidth: calcWidth())
                                                    .padding(.vertical, 10)
                                                    .border(Color.black, width: 1)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 0) {
                        Text("")
                            .frame(minWidth: 87, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                        
                        Text("Comparison Weak")
                            .frame(minWidth: 522, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black, width: 1)
                    }
                    
                    // Main Headers
                    Headers()
                    
                    // Rows
                    ForEach(Case.allCases, id: \.rawValue) { c in
                        HStack(spacing: 0) {
                            Text(c.rawValue.capitalized)
                                .frame(minWidth: 87, maxWidth: 87)
                                .padding(.vertical, 10)
                                .border(Color.black, width: 1)
                                .background(Color.gray.opacity(0.2))
                            
                            ForEach(Number.allCases, id: \.rawValue) { num in
                                if num == .plural {
                                    if let weakAdjective = word.generateComparisonWeakAdjective(number: num, gender: .any, caseWeak: c) {
                                        Text(weakAdjective)
                                            .frame(minWidth: 261, maxWidth: 261)
                                            .padding(.vertical, 10)
                                            .border(Color.black, width: 1)
                                    }
                                } else {
                                    if word.shouldShowNumber(number: num) {
                                        ForEach(Gender.allCases, id: \.rawValue) { gen in
                                            if word.shouldShowGender(number: num, gen: gen) {
                                                if let weakAdjective = word.generateComparisonWeakAdjective(number: num, gender: gen, caseWeak: c) {
                                                    Text(weakAdjective)
                                                        .frame(minWidth: calcWidth(), maxWidth: calcWidth())
                                                        .padding(.vertical, 10)
                                                        .border(Color.black, width: 1)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func withArticle(c: Case, num: Number) -> String? {
        if word.type == .noun {
            if let wordWithCase = word.generateNounCase(nounCase: c, number: num, article: true) {
                return " (\(wordWithCase))"
            }
        }
        
        return ""
    }
    
    private func headerWidth(for number: Number) -> CGFloat {
        let subheaderCount = word.countGenders(for: number)
        
        if word.type == .noun {
            return CGFloat(subheaderCount) * 87.0 * 2
        } else {
           return CGFloat(subheaderCount) * 87.0
        }
    }
    
    func calcWidth() -> CGFloat {
        if word.type == .noun {
            return CGFloat(174.0)
        }
        
        return CGFloat(87.0)
    }
}

struct DynamicTable_Previews: PreviewProvider {
    static var previews: some View {
        let sampleWord = Word(oldNorseWord: "Hús", base: "huse", declension: nil, englishTranslation: "House", russianTranslation: "Дом", definition: "A building for human habitation.", examples: ["Hús er stafrænt orðn sem merkir byggingu fyrir mannlega búsetu."], type: .noun, cases: nil, gendersCases: nil, numbers: nil, conjugation: nil, verbForms: nil, gender: nil, nounForms: nil, comparative: nil, comparison: nil)

        DynamicTable(word: sampleWord)
    }
}
