import Foundation

extension AOC_2021 {
    struct Day14Const {
        static let MAX_DEPTH = 40 // aka steps
    }
    
    public static func day14() {
        struct Instruction: Hashable {
            var leftPolimer: String
            var rightPolimer: String
            var insertionPolimer: String
            
            var cachedPolimerCountsAfterNStep: [Dictionary<String, Int>?] = Array(repeating: nil, count: Day14Const.MAX_DEPTH)
            
            func matches(leftPolimer: String, rightPolimer: String) -> Bool {
                return leftPolimer == self.leftPolimer && rightPolimer == self.rightPolimer
            }
        }
        
        if let path = Bundle.main.path(forResource: "input_day14", ofType: "txt") {
            let data = try! String(contentsOfFile: path, encoding: .utf8)
            
            let lines = data.components(separatedBy: .newlines)
            
            let polimerTemplate = lines[0]
            var instructions: [Instruction] = lines.dropFirst(2).compactMap {
                if $0.isEmpty { return nil }
                
                let split = $0.components(separatedBy: " -> ")
                return Instruction(leftPolimer: String(split[0][0]), rightPolimer: String(split[0][1]), insertionPolimer: split[1])
            }
            
            // Parsed!
            
            func recursivePutNewElementAndCount(leftElement: String, rightElement: String, depthNow: Int) -> Dictionary<String, Int> {
                if depthNow >= Day14Const.MAX_DEPTH { return [:] }
                
                if let foundIndex = instructions.firstIndex(where: {$0.matches(leftPolimer: leftElement, rightPolimer: rightElement)}) {
                    let found = instructions[foundIndex]
                    if let countAfterNsteps = found.cachedPolimerCountsAfterNStep[Day14Const.MAX_DEPTH - depthNow - 1] {
                        // We already computed the values previously - lets use that.
                        return countAfterNsteps
                    }
                    
                    var tempDictionary = recursivePutNewElementAndCount(leftElement: leftElement, rightElement: found.insertionPolimer, depthNow: depthNow + 1)
                    tempDictionary.incrementByOrPut(key: found.insertionPolimer, by: 1)
                    recursivePutNewElementAndCount(leftElement: found.insertionPolimer, rightElement: rightElement, depthNow: depthNow + 1).forEach {
                        tempDictionary.incrementByOrPut(key: $0.key, by: $0.value)
                    }
                    
                    // Update the dictionary with the values we just computed
                    instructions[foundIndex].cachedPolimerCountsAfterNStep[Day14Const.MAX_DEPTH - depthNow - 1] = tempDictionary
                    return tempDictionary
                }
                
                return [:]
            }
            
            var polimerDictionary: Dictionary<String, Int> = [:]
            polimerTemplate.forEach { polimerDictionary.incrementByOrPut(key: String($0), by: 1)}
            
            for i in 0..<polimerTemplate.count - 1 {
                print("DOING LOOP \(i+1) out of \(polimerTemplate.count - 1)")
                recursivePutNewElementAndCount(leftElement: String(polimerTemplate[i]), rightElement: String(polimerTemplate[i+1]), depthNow: 0).forEach{
                    polimerDictionary.incrementByOrPut(key: $0.key, by: $0.value)
                }
            }
            
            let sortedDictionary = polimerDictionary.sorted(by: {$0.value < $1.value})
            let minValue = sortedDictionary.first!.value
            let maxValue = sortedDictionary.last!.value
            
            print("Polimer dictionary (sorted): \(sortedDictionary)\nMin value: \(minValue)\nMax value: \(maxValue)\nDifference: \(maxValue - minValue)")
        }
    }
}

extension Dictionary where Key == String, Value == Int {
    mutating func incrementByOrPut(key: String, by value: Int) {
        self[key] = self[key] == nil ? value : self[key]! + value
    }
}
