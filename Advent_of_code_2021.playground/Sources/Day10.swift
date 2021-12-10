import Foundation

extension AOC_2021 {
    public static func day10() {
        struct CharacterStack {
            var items: [Character] = []
            mutating func push(_ item: Character) {
                items.append(item)
            }
            mutating func pop() -> Character {
                return items.removeLast()
            }
            var count: Int { items.count }
        }
        
        if let path = Bundle.main.path(forResource: "input_day10", ofType: "txt") {
            let data = try! String(contentsOfFile: path, encoding: .utf8)
            
//            let data = "{([(<{}[<>[]}>{[]{[(<()>"
//            let data = "[({(<(())[]>[[{[]{<()<>>"
            
            let lines: [String] = data.components(separatedBy: .newlines).compactMap {
                if $0.count == 0 { return nil }
                return $0
            }
            
            func isClosingSymbol(symbol: Character) -> Bool {
                return symbol == ")" || symbol == "]" || symbol == "}" || symbol == ">"
            }
            
            func areMatching(opening: Character, closing: Character) -> Bool {
                return opening == "(" && closing == ")"
                    || opening == "[" && closing == "]"
                    || opening == "{" && closing == "}"
                    || opening == "<" && closing == ">"
            }
            
            let openingToClosingDictionary: [Character: Character] = ["(":")",
                                                                "[":"]",
                                                                "{":"}",
                                                                "<":">"]
            
            let scoringDictionary: [Character: Int] = [")": 3,
                                                    "]": 57,
                                                    "}": 1197,
                                                    ">": 25137]
            
            let part2scoringDictionary: [Character: Int] = [")": 1,
                                                            "]": 2,
                                                            "}": 3,
                                                            ">": 4]

            var score: [Int] = []
            
            lines.forEach { line in
                var stack = CharacterStack()
                var isLineCorrupted = false
                for symbol in line {
                    if isClosingSymbol(symbol: symbol) {
                        let openingSymbol = stack.pop()
                        if !(areMatching(opening: openingSymbol, closing: symbol)) {
                            print("Expected \(openingToClosingDictionary[openingSymbol]!), got \(symbol) instead")
//                            score += scoringDictionary[symbol]! // part 1 scoring
                            isLineCorrupted = true
                            break
                        }
                    } else {
                        stack.push(symbol)
                    }
                }
                if !isLineCorrupted {
                    // means line is not closed properly
                    
                    var helperString = ""
                    while stack.count != 0 {
                        helperString = helperString + String(openingToClosingDictionary[stack.pop()]!)
                    }
                    print("Not closed symbols: \(helperString)")
                }
            }
            print("Score is: \(score)")
            
        }
    }
}
