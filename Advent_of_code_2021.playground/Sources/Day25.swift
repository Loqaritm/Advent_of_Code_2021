import Foundation

public struct AOC_2021_Day25 {
    public struct SeaCucumberMapState {
        var seaCucumbers: [[Character]]
        var isFinished = false
        
        public mutating func nextStepState(rightFacing: Bool) -> Bool {
            var nextState = seaCucumbers
//            var nextState: [[Character]] = Array(repeating: Array(repeating: ".", count: seaCucumbers[0].count), count: seaCucumbers.count)
            
            var finished = true
            for i in seaCucumbers.indices {
                for j in seaCucumbers[0].indices {
                    if rightFacing
                        && seaCucumbers[i][j] == ">"
                        && seaCucumbers[i][ (j+1) % seaCucumbers[0].count ] == "." {
                        // Move
                        nextState[i][(j+1) % seaCucumbers[0].count] = ">"
                        nextState[i][j] = "."
                        finished = false
                    } else if !rightFacing
                        && seaCucumbers[i][j] == "v"
                        && seaCucumbers[(i+1) % seaCucumbers.count][j] == "." {
                        // Move down
                        nextState[(i+1) % seaCucumbers.count][j] = "v"
                        nextState[i][j] = "."
                        finished = false
                    }
                }
            }
            
            seaCucumbers = nextState
            return finished
        }
    }
    
    
    public static func parse(stringData: String) -> SeaCucumberMapState {
        let parsedMap: [[Character]] = stringData.components(separatedBy: .newlines).compactMap {
            if $0.isEmpty { return nil }
            return Array($0)
        }
        return SeaCucumberMapState(seaCucumbers: parsedMap)
    }
    
    public static func runInternal(stringData: String) -> Int {
        var cucumbersMapState = parse(stringData: stringData)
        
        var steps = 0
        while !cucumbersMapState.isFinished {
            print("Doing step \(steps)")
            let rightStep = cucumbersMapState.nextStepState(rightFacing: true)
            let downStep = cucumbersMapState.nextStepState(rightFacing: false)
            cucumbersMapState.isFinished = rightStep && downStep
            steps += 1
        }
        
        for cucumbers in cucumbersMapState.seaCucumbers {
            print(cucumbers.reduce("", {$0 + String($1)}))
        }
        
        return steps
    }
    
    public static func run() {
        if let path = Bundle.main.path(forResource: "input_day25", ofType: "txt") {
            // Remember to drop the newline at the end
            let stringData = try! String(contentsOfFile: path, encoding: .utf8)
            let steps = runInternal(stringData: stringData)
            print("Sea cucumbers stopped moving after: \(steps) steps")
        }
    }
    
}


// MARK: Unit tests
import XCTest

public class Day25Tests: XCTestCase {
    func testDay25() {
        let inputData = """
        v...>>.vv>
        .vv>>.vv..
        >>.>v>...v
        >>v>>.>.v.
        v>v.vv.v..
        >.>>..v...
        .vv..>.>v.
        v.v..>>v.v
        ....v..v.>
        """
        
        XCTAssertEqual(AOC_2021_Day25.runInternal(stringData: inputData), 58)
    }
}
