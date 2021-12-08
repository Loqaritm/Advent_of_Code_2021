import Foundation

extension AOC_2021 {
    public static func day8() {
        struct Line {
            var uniqueSignals: [String]
            var outputs: [String]
        }
        
        struct SevenSegmentDisplay {
            public static func isOne(segments: String) -> Bool {
                segments.count == 2 // Simple one, unique number of segments
            }
            public static func isFour(segments: String) -> Bool {
                segments.count == 4
            }
            public static func isSeven(segments: String) -> Bool {
                segments.count == 3
            }
            public static func isEight(segments: String) -> Bool {
                segments.count == 7
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
            
            // Part 1 - count only easy ones, so 1, 4, 7, 8
            var counted = 0
            lines.forEach {
                $0.outputs.forEach {
                    if SevenSegmentDisplay.isOne(segments: $0)
                        || SevenSegmentDisplay.isFour(segments: $0)
                        || SevenSegmentDisplay.isSeven(segments: $0)
                        || SevenSegmentDisplay.isEight(segments: $0)
                    {
                        counted += 1
                    }
                }
            }
            
            
            print("Number of 1, 4, 7 or 8s: \(counted)")
            
        }
    }
}
