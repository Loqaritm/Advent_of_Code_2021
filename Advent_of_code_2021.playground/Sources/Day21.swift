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
    
    public struct Player: Identifiable, Hashable {
        internal init(currentPosition: Int, id: Int) {
            self.currentPosition = currentPosition - 1
            self.id = id
        }
        
        // Position is internally 0...9, while externally its 1...10
        private(set) var currentPosition: Int
        public var id: Int
        private(set) var score = 0
        var wins: UInt64 = 0
        
        mutating func movePlayer(by: Int) {
            currentPosition += by
            currentPosition = currentPosition % 10
            score += currentPosition + 1
        }
    }
    
    public static func parse(stringData: String) -> [Player] {
        var id = 0
        return stringData.components(separatedBy: .newlines).compactMap{
            if $0.isEmpty { return nil }
            let returnData = Player(currentPosition: Int($0.components(separatedBy: ": ")[1])!, id: id)
            id += 1
            return returnData
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
    
    public static func runInternalPart2(stringData: String) -> (UInt64, UInt64) {
        let players = parse(stringData: stringData)
        
        struct PlayerPair: Hashable {
            static func == (lhs: PlayerPair, rhs: PlayerPair) -> Bool {
                return lhs.player1.currentPosition == rhs.player1.currentPosition
                    && lhs.player1.score == rhs.player1.score
                    && lhs.player2.currentPosition == rhs.player2.currentPosition
                    && lhs.player2.score == rhs.player2.score
            }
            
            var player1: Player
            var player2: Player
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(player1.currentPosition)
                hasher.combine(player1.score)
                hasher.combine(player2.currentPosition)
                hasher.combine(player2.score)
            }
        }
        
        var cache = [PlayerPair: (UInt64, UInt64)]()
        
        func recursivePlay(currentPlayer: Player, otherPlayer: Player) -> (UInt64, UInt64) {
            if otherPlayer.score >= 21 {
                return (0, 1)
            }
            
            var nextWinsThisPlayer: UInt64 = 0
            var nextWinsOtherPlayer: UInt64 = 0
            
            // now, let's roll the dices!
            // Roll all three at the same time
            for roll1 in 1...3 {
                for roll2 in 1...3 {
                    for roll3 in 1...3 {
                        var helperPlayer = currentPlayer
                        helperPlayer.movePlayer(by: roll1 + roll2 + roll3)
                        // Also switch to the other player as main player
                        if let cachedValue = cache[PlayerPair(player1: otherPlayer, player2: helperPlayer)] {
                            nextWinsThisPlayer += cachedValue.0
                            nextWinsOtherPlayer += cachedValue.1
                            continue
                        }
                        let (numWinsThisPlayer, numWinsOtherPlayer) = recursivePlay(currentPlayer: otherPlayer, otherPlayer: helperPlayer)
                        cache[PlayerPair(player1: otherPlayer, player2: helperPlayer)] = (numWinsThisPlayer, numWinsOtherPlayer)
                        nextWinsThisPlayer += numWinsThisPlayer
                        nextWinsOtherPlayer += numWinsOtherPlayer
                    }
                }
            }
            return (nextWinsOtherPlayer, nextWinsThisPlayer)
        }
        
        
        
        return recursivePlay(currentPlayer: players[0], otherPlayer: players[1])
    }
    
    
    public static func run() {
        let stringData = """
        Player 1 starting position: 7
        Player 2 starting position: 5
        """
        
        let returnedValue = runInternal(stringData: stringData)
        print("Computed is: \(returnedValue)")
    }
    
    public static func runPart2() {
        let stringData = """
        Player 1 starting position: 7
        Player 2 starting position: 5
        """
        
        let (playerOneWins, playerTwoWins) = runInternalPart2(stringData: stringData)
        print("Player one wins: \(playerOneWins), Player two wins: \(playerTwoWins)")
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
    
    func testDay21_part2() {
        let testData = """
        Player 1 starting position: 4
        Player 2 starting position: 8
        """

        let (player1wins, player2wins) = AOC_2021_Day21.runInternalPart2(stringData: testData)
        XCTAssertEqual(player1wins, 444356092776315)
        XCTAssertEqual(player2wins, 341960390180808)
    }
}
