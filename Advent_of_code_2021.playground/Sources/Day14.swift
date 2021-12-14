import Foundation

extension AOC_2021 {
    public static func day14() {
        struct Instruction: Hashable {
            var leftPolimer: String
            var rightPolimer: String
            var insertionPolimer: String
            
            func matches(leftPolimer: String, rightPolimer: String) -> Bool {
                return leftPolimer == self.leftPolimer && rightPolimer == self.rightPolimer
            }
        }
        
        if let path = Bundle.main.path(forResource: "input_day14", ofType: "txt") {
            let data = try! String(contentsOfFile: path, encoding: .utf8)
            
            let lines = data.components(separatedBy: .newlines)
            
            let polimerTemplate = lines[0]
            let instructions: [Instruction] = lines.dropFirst(2).compactMap {
                // Just to
                if $0.isEmpty { return nil }
                
                let split = $0.components(separatedBy: " -> ")
                return Instruction(leftPolimer: String(split[0][0]), rightPolimer: String(split[0][1]), insertionPolimer: split[1])
            }
            
            // Parsed!
            
            let MAX_DEPTH = 10
            var polimerDictionary: Dictionary<String, Int> = [:]
            polimerTemplate.forEach { polimerDictionary.incrementByOrPut(key: String($0))}
            
            func recursivePutNewElementAndCount(leftElement: String, rightElement: String, depthNow: Int) {
                if depthNow >= MAX_DEPTH { return }
                
                if let found = instructions.first(where: {$0.matches(leftPolimer: leftElement, rightPolimer: rightElement)}) {
                    // We put new element, so increase it's count
                    polimerDictionary.incrementByOrPut(key: found.insertionPolimer)
                    
                    recursivePutNewElementAndCount(leftElement: leftElement, rightElement: found.insertionPolimer, depthNow: depthNow + 1)
                    recursivePutNewElementAndCount(leftElement: found.insertionPolimer, rightElement: rightElement, depthNow: depthNow + 1)
                }
            }
            
            // ignore last element
            for i in 0..<polimerTemplate.count - 1 {
//                print("DOING LOOP \(i+1) out of \(polimerTemplate.count - 1)")
                recursivePutNewElementAndCount(leftElement: String(polimerTemplate[i]), rightElement: String(polimerTemplate[i+1]), depthNow: 0)
            }
            
            let sortedDictionary = polimerDictionary.sorted(by: {$0.value < $1.value})
            let minValue = sortedDictionary.first!.value
            let maxValue = sortedDictionary.last!.value
            
            print("Polimer dictionary (sorted): \(sortedDictionary)\nMin value: \(minValue)\nMax value: \(maxValue)\nDifference: \(maxValue - minValue)")
        }
    }
}

extension Dictionary where Key == String, Value == Int {
    mutating func incrementByOrPut(key: String) {
        self[key] = self[key] == nil ? 1 : self[key]! + 1
    }
}
