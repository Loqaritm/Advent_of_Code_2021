import Foundation

extension AOC_2021 {
    public static func day8() {
        struct Line {
            var uniqueSignals: [String]
            var outputs: [String]
        }
        
        struct SevenSegmentDisplay {
            internal init(one: String, seven: String, four: String, eight: String) {
                self.one = one
                self.seven = seven
                self.four = four
                self.eight = eight
            }

            // Segments go:
            //   000
            //  1   2
            //  1   2
            //   333
            //  4   5
            //  4   5
            //   666
            //
            // Numbers expressed using those segments:
            // 0: 0,1,2,4,5,6
            // 1: 2,5
            // 2: 0,2,3,4,6
            // 3: 0,2,3,5,6
            // 4: 1,2,3,5
            // 5: 0,1,3,5,6
            // 6: 0,1,3,4,5,6
            // 7: 0,2,5
            // 8: 0,1,2,3,4,5,6
            // 9: 0,1,2,3,5,6
            //
            //
            // Known:
            // 1: 2,5
            // 7: 0,2,5
            // 4: 1,2,3,5
            // 8: 0,1,2,3,4,5,6 - can ignore, it's just all segments
            //
            // Unknown
            // 3: 0,2,3,5,6 - those segments - "1" symbols == 3 segments; else must be 2 or 5
            // 2: 0,2,3,4,6 - those segments - ("4" segments - "1" segments) == 4 segments
            // 5: 0,1,3,5,6 -               else this
            // 6: 0,1,3,4,5,6 - those segments - "1" segments == 5 segments; else (because 5 segments left) must be either 0 or 9
            // 0: 0,1,2,4,5,6 - those segments - "4" segments == 3 segments
            // 9: 0,1,2,3,5,6 - those segments - "4" segments == 2 segments
            
            public func getDigit(jumbled: String) -> String {
                let digit = String(jumbled.sorted())
                if digit == one { return "1" }
                if digit == seven { return "7" }
                if digit == four { return "4" }
                if digit == eight { return "8" }
                
                if digit.count == 5 {
                    // Must be 2,3 or 5
                    if digit.filter({!one.contains($0)}).count == 3 {
                        return "3"
                    } else if digit.filter({!four.filter{!one.contains($0)}.contains($0)}).count == 4 {
                        return "2"
                    } else {
                        return "5"
                    }
                } else {
                    // Must be 0, 6 or 9
                    if digit.filter({!one.contains($0)}).count == 5 {
                        return "6"
                    } else if digit.filter({!four.contains($0)}).count == 3 {
                        return "0"
                    } else {
                        return "9"
                    }
                }
            }
            
            // Known
            private var _one: String = ""
            var one: String {
                get {_one}
                set {_one = String(newValue.sorted())}
            }
            private var _seven: String = ""
            var seven: String {
                get {_seven}
                set {_seven = String(newValue.sorted())}
            }
            private var _four: String = ""
            var four: String {
                get {_four}
                set {_four = String(newValue.sorted())}
            }
            private var _eight: String = ""
            var eight: String {
                get {_eight}
                set {_eight = String(newValue.sorted())}
            }
        }
        
        
        if let path = Bundle.main.path(forResource: "input_day8", ofType: "txt") {
//            let testData = "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe"
            let data = try! String(contentsOfFile: path, encoding: .utf8)
            
            let lines: [Line] = data.components(separatedBy: .newlines).compactMap { line in
                if line.isEmpty { return nil }
                let splitLine: [String] = line.components(separatedBy: " | ")
                if splitLine.count != 2 || splitLine[0].isEmpty || splitLine[1].isEmpty { return nil }
                return Line(uniqueSignals: splitLine[0].components(separatedBy: " "), outputs: splitLine[1].components(separatedBy: " "))
            }
            
            // Parsed!

            var sumOfNumbers = 0
            lines.forEach { line in
                let sortedSignals = line.uniqueSignals.sorted{$0.count < $1.count}.compactMap{String($0.sorted())}
                let one = sortedSignals.first(where: {$0.count == 2})!
                let seven = sortedSignals.first(where: {$0.count == 3})!
                let four = sortedSignals.first(where: {$0.count == 4})!
                let eight = sortedSignals.first(where: {$0.count == 7})!
                print("1: \(one), 7: \(seven), 4: \(four), 8: \(eight)")
                let sevenSegmentDisplay = SevenSegmentDisplay(one: one, seven: seven, four: four, eight: eight)
                
                var outputNumber = ""
                line.outputs.forEach { output in
                    let decodedDigit = sevenSegmentDisplay.getDigit(jumbled: output)
                    print("For output: \(output) decoded string is \(decodedDigit)")
                    outputNumber = outputNumber + decodedDigit
                }
                sumOfNumbers += Int(outputNumber)!
            }
            
            print("Sum of output numbers is: \(sumOfNumbers)")
        }
    }
}
