import Foundation

public struct AOC_2021_Day20 {
    static func parse(stringData: String) -> (String, [[Character]]) {
        let parts = stringData.components(separatedBy: "\n\n")
        let imageEnhancementData = parts[0].components(separatedBy: .newlines)[0]
        let inputImage: [[Character]] = parts[1].components(separatedBy: .newlines).compactMap {
            if $0.isEmpty { return nil }
            return $0.compactMap{$0}
        }
        
        return (imageEnhancementData, inputImage)
    }
    
    static func get3x3matrixCenterEnhancedValue(matrix: [[Character]], enhancementData: String) -> Character {
        let computedString = matrix.reduce("", {$0 + $1.reduce("", {$0 + (String($1) == "#" ? "1" : "0") })})
        let computedValue = Int(computedString, radix: 2)!
        return enhancementData[computedValue]
    }
    
    static func getNumberOfLitUpPoints(matrix: [[Character]]) -> Int {
        return matrix.reduce(0, {$0 + $1.reduce(0, {$0 + (String($1) == "#" ? 1 : 0)})})
    }
    
    public static func runInternal(stringData: String, times: Int) -> Int {
        let (imageEnhancementData, inputMatrix) = parse(stringData: stringData)
        
        var lightUpMatrix = inputMatrix
        var padWith: Character = "." // Orignally pad with empty
        for _ in 0..<times {
            // Add padding
            let paddedMatrix = lightUpMatrix.pad2DArray(with: padWith, top: 2, left: 2, right: 2, bottom: 2)
            padWith = get3x3matrixCenterEnhancedValue(matrix: Array(repeating: Array(repeating: padWith, count: 3), count: 3), enhancementData: imageEnhancementData)
            
            var nextMatrix = paddedMatrix
            
            let minPosition = 0
            let maxPositionX = paddedMatrix.count - 1
            let maxPositionY = paddedMatrix[0].count - 1
            for i in minPosition...maxPositionX {
                for j in minPosition...maxPositionY {
                    if i == minPosition || i == maxPositionX
                    || j == minPosition || j == maxPositionY {
                        // We need to handle those separately - they are in the current play, but require
                        // values that are not yet actually generated. But we know their value
                        nextMatrix[i][j] = padWith
                        continue
                    }
                    let kernel = paddedMatrix[i-1...i+1].map{$0[j-1...j+1].compactMap{$0}}
                    nextMatrix[i][j] = get3x3matrixCenterEnhancedValue(matrix: kernel, enhancementData: imageEnhancementData)
                }
            }
            lightUpMatrix = nextMatrix
        }
        return getNumberOfLitUpPoints(matrix: lightUpMatrix)
    }
    
    public static func run() {
        if let path = Bundle.main.path(forResource: "input_day20", ofType: "txt") {
            let stringData = try! String(contentsOfFile: path, encoding: .utf8)
            
            let litUpPoints = runInternal(stringData: stringData, times: 50)
            print("Number of lit up points: \(litUpPoints)")
        }
    }
}

// MARK: Unit tests
import XCTest

public class Day20Tests: XCTestCase {
    func testDay20_part1() {
        let testData = """
        ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

        #..#.
        #....
        ##..#
        ..#..
        ..###
        """
        
        XCTAssertEqual(AOC_2021_Day20.runInternal(stringData: testData, times: 2), 35)
        XCTAssertEqual(AOC_2021_Day20.runInternal(stringData: testData, times: 50), 3351)
    }
}
