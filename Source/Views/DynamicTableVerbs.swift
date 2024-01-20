import SwiftUI

struct DynamicTableVerbs: View {
    let word: Word
    
    func Headers(tense: Tense, reflexive: Bool) -> some View {
        Group {
            HStack(spacing: 0) {
                Text("")
                    .frame(minWidth: 87, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .border(Color.black, width: 1)
                
                Text(tense.Title(reflexive: reflexive))
                    .frame(minWidth: 522, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .border(Color.black, width: 1)
            }
            
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
        }
    }
    
    
    func Rows(tense: Tense, reflexive: Bool) -> some View {
        ForEach(Person.allCases, id: \.rawValue) { p in
            HStack(spacing: 0) {
                Text(p.rawValue.capitalized)
                    .frame(minWidth: 87, maxWidth: 87)
                    .padding(.vertical, 10)
                    .border(Color.black, width: 1)
                    .background(Color.gray.opacity(0.2))
                
                ForEach(Number.allCases, id: \.rawValue) { num in
                    if word.shouldShowNumber(number: num) {
                        if let wordWithConjunction = word.generateConjugation(person: p, number: num, tense: tense, reflexive: reflexive) {
                            Text(wordWithConjunction)
                                .frame(minWidth: headerWidth(for: num), maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .border(Color.black, width: 1)
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack(alignment: .leading) {
                // present tense
                Headers(tense: .present, reflexive: false)
                
                HStack(spacing: 0) {
                    Text("Imperative")
                        .frame(minWidth: 87, maxWidth: 87)
                        .padding(.vertical, 10)
                        .border(Color.black, width: 1)
                        .background(Color.gray.opacity(0.2))
                    
                    ForEach(Number.allCases, id: \.rawValue) { num in
                        if word.shouldShowNumber(number: num) {
                            if let wordWithConjunction = word.generateImperative(number: num) {
                                Text(wordWithConjunction)
                                    .frame(minWidth: headerWidth(for: num), maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .border(Color.black, width: 1)
                            }
                        }
                    }
                }
                
                Rows(tense: .present, reflexive: false)
        

                // past tense
                Headers(tense: .past, reflexive: false)
                
                Rows(tense: .past, reflexive: false)

                // present tense reflexive
                Headers(tense: .present, reflexive: true)

                HStack(spacing: 0) {
                    Text("Imperative")
                        .frame(minWidth: 87, maxWidth: 87)
                        .padding(.vertical, 10)
                        .border(Color.black, width: 1)
                        .background(Color.gray.opacity(0.2))
                    
                    ForEach(Number.allCases, id: \.rawValue) { num in
                        if word.shouldShowNumber(number: num) {
                            if let wordWithConjunction = word.generateImperativeReflexive(number: num) {
                                Text(wordWithConjunction)
                                    .frame(minWidth: headerWidth(for: num), maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .border(Color.black, width: 1)
                            }
                        }
                    }
                }
                
                Rows(tense: .present, reflexive: true)
                
                // past tense reflexive
                Headers(tense: .past, reflexive: true)
                Rows(tense: .past, reflexive: true)
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

struct DynamicTableVerbs_Previews: PreviewProvider {
    static var previews: some View {
        let sampleWord = Word(oldNorseWord: "Hús", base: "huse", declension: nil, englishTranslation: "House", russianTranslation: "Дом", definition: "A building for human habitation.", examples: ["Hús er stafrænt orðn sem merkir byggingu fyrir mannlega búsetu."], type: .noun, cases: nil, gendersCases: nil, numbers: nil, conjugation: nil, verbForms: nil, gender: nil, nounForms: nil, comparative: nil, comparison: nil)

        DynamicTable(word: sampleWord)
    }
}
