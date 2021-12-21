import Foundation

public struct AOC_2021_Day21 {
    class DeterministicDice {
        private var _currentResult = 1
        
        func rollDice() -> Int {
            let returnedValue = _currentResult
            _currentResult += 1
            if _currentResult > 100 { _currentResult = 1 }
            return returnedValue
        }
    }
    
    public struct Player {
        internal init(currentPosition: Int) {
            self.currentPosition = currentPosition - 1
        }
        
        // Position is internally 0...9, while externally its 1...10
        private(set) var currentPosition: Int
        private(set) var score = 0
        
        mutating func movePlayer(by: Int) {
            currentPosition += by
            currentPosition = currentPosition % 10
            score += currentPosition + 1
        }
    }
    
    public static func parse(stringData: String) -> [Player] {
        stringData.components(separatedBy: .newlines).compactMap{
            if $0.isEmpty { return nil }
            return Player(currentPosition: Int($0.components(separatedBy: ": ")[1])!)
        }
    }
    
    public static func runInternal(stringData: String) -> Int {
        let dice = DeterministicDice()
        var players = parse(stringData: stringData)
        
        var currentPlayerIndex = 0
        var timesDiceWasRolled = 0
        while !players.contains(where: {$0.score >= 1000 }) {
            var moveBy = 0
            for _ in 0..<3 {
                moveBy += dice.rollDice()
                timesDiceWasRolled += 1
            }
            
            players[currentPlayerIndex].movePlayer(by: moveBy)
            currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        }
        
//        print("Score: \(players[currentPlayerIndex].score), times dice was rolled: \(timesDiceWasRolled)")
        return players[currentPlayerIndex].score * timesDiceWasRolled
    }
    
//    public static func runInternalPart2() -> Int {
//        var universesWithPoints = Array(repeating: 0, count: 21)
//        
//        // Smallest number to move is 3
//        // Largest is 9
//        
//        var currentPlayerIndex = 0
//    }
    
    public static func run() {
        let stringData = """
        Player 1 starting position: 7
        Player 2 starting position: 5
        """
        
        let returnedValue = runInternal(stringData: stringData)
        print("Computed is: \(returnedValue)")
    }
}

// MARK: Unit tests
import XCTest

public class Day21Tests: XCTestCase {
    func testDay21_part1() {
        let testData = """
        Player 1 starting position: 4
        Player 2 starting position: 8
        """
        
        XCTAssertEqual(AOC_2021_Day21.runInternal(stringData: testData), 739785)
    }
}
