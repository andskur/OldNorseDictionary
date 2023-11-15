import SwiftUI

struct DynamicTable: View {
    let word: Word
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack(alignment: .leading) {
                // Main Headers
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
                
                // Sub-Headers
                HStack(spacing: 0) {
                    Text("")
                        .frame(minWidth: 87, maxWidth: 87)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.2))
                        .border(Color.black, width: 1)
                    
                    ForEach(Number.allCases, id: \.rawValue) { num in
                        if word.shouldShowNumber(number: num) {
                            ForEach(Gender.allCases, id: \.rawValue) { gen in
                                if word.shouldShowGender(number: num, gender: gen) {
                                    Text(gen.rawValue.capitalized)
                                        .frame(minWidth: 87, maxWidth: 87)
                                        .padding(.vertical, 10)
                                        .background(Color.gray.opacity(0.2))
                                        .border(Color.black, width: 1)
                                }
                            }
                        }
                    }
                }
                
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
                                    if word.shouldShowGender(number: num, gender: gen) {
                                        if let wordWithCase = word.generateCase(wordCase: c, number: num, gender: gen) {
                                            Text(wordWithCase)
                                                .frame(minWidth: 87, maxWidth: 87)
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
    
    private func headerWidth(for number: Number) -> CGFloat {
        let subheaderCount = word.countGenders(for: number)
        return CGFloat(subheaderCount) * 87.0
    }
}

struct DynamicTable_Previews: PreviewProvider {
    static var previews: some View {
        let sampleWord = Word(oldNorseWord: "Hús", base: "hus", englishTranslation: "House", russianTranslation: "Дом", definition: "A building for human habitation.", examples: ["Hús er stafrænt orð sem merkir byggingu fyrir mannlega búsetu."], type: .noun, cases: nil, gendersCases: nil, numbers: nil, conjugation: nil, verbFirst: nil, verbSecond: nil)

        DynamicTable(word: sampleWord)
    }
}
