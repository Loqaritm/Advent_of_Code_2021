import Foundation

public struct AOC_2021_Day22 {
    public struct Instruction {
        enum InstructionType {
            case on
            case off
        }
        
        var instructionType: InstructionType
        var x: ClosedRange<Int>
        var y: ClosedRange<Int>
        var z: ClosedRange<Int>
    }
    
    public struct Point: Hashable {
        internal init(_ x: Int, _ y: Int, _ z: Int) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        var x: Int
        var y: Int
        var z: Int
    }
    
    public struct Reactor {
        var xRangesOn: [ClosedRange<Int>] = []
        var yRangesOn: [ClosedRange<Int>] = []
        var zRangesOn: [ClosedRange<Int>] = []
        
        var cubes = Set<Point>()
    }
    
    public static func parse(stringData: String, trim: Int? = nil) -> [Instruction] {
        stringData.components(separatedBy: .newlines).compactMap {
            if $0.isEmpty { return nil }
            
            let parts = $0.components(separatedBy: " ")
            let instructionType = parts[0] == "on" ? Instruction.InstructionType.on : Instruction.InstructionType.off
            
            let boundsArray: [String] = parts[1].components(separatedBy: ",").flatMap {
                $0.components(separatedBy: "..")
            }
            
            var boundsIntArray: [Int] = [
                Int(boundsArray[0].dropFirst(2))!, Int(boundsArray[1])!,
                Int(boundsArray[2].dropFirst(2))!, Int(boundsArray[3])!,
                Int(boundsArray[4].dropFirst(2))!, Int(boundsArray[5])!
            ]
            
            if let trimSafe = trim {
                for i in boundsIntArray.indices {
                    boundsIntArray[i] = max(boundsIntArray[i], -trimSafe)
                    boundsIntArray[i] = min(boundsIntArray[i], trimSafe)
                    
                    if i % 2 == 1
                        && (boundsIntArray[i] == trimSafe || boundsIntArray[i] == -trimSafe)
                        && boundsIntArray[i] == boundsIntArray[i-1] {
                        // Ignore bounds where xm == xM
                        return nil
                    }
                }
            }
            
            return Instruction(instructionType: instructionType,
                               x: boundsIntArray[0]...boundsIntArray[1],
                               y: boundsIntArray[2]...boundsIntArray[3],
                               z: boundsIntArray[4]...boundsIntArray[5])
        }
    }
    
    public static func runInternal(stringData: String, trim: Int? = nil) -> Int {
        let instructions = parse(stringData: stringData, trim: trim)

        var reactor = Reactor()

        instructions.enumerated().forEach { (n,instructionIn) in
            let instruction = instructionIn
//            print("Step: \(n+1)/\(instructions.count)")
            for x in instruction.x {
                for y in instruction.y {
                    for z in instruction.z {
                        if instruction.instructionType == .on { reactor.cubes.insert(Point(x, y, z)) }
                        else { reactor.cubes.remove(Point(x, y, z)) }
                    }
                }
            }
        }
        
        return reactor.cubes.count
    }
    
//    public static func run() {
//        if let path = Bundle.main.path(forResource: "input_day22", ofType: "txt") {
//            let stringData = try! String(contentsOfFile: path, encoding: .utf8)
////            let cubeCount = AOC_2021_Day22.runInternal(stringData: stringData)
////            print("Count of all cubes turned on: \(cubeCount)")
//        }
//    }
}

import XCTest

public class Day22Tests: XCTestCase {
    func testDay22_part1() {
        let testData = """
        on x=10..12,y=10..12,z=10..12
        on x=11..13,y=11..13,z=11..13
        off x=9..11,y=9..11,z=9..11
        on x=10..10,y=10..10,z=10..10
        """
        
        let cubesOn = AOC_2021_Day22.runInternal(stringData: testData, trim: 50)
        print(cubesOn)
        XCTAssertEqual(cubesOn, 39)
    }
    
    func testDay22_part1_largerSet() {
        let testData = """
        on x=-20..26,y=-36..17,z=-47..7
        on x=-20..33,y=-21..23,z=-26..28
        on x=-22..28,y=-29..23,z=-38..16
        on x=-46..7,y=-6..46,z=-50..-1
        on x=-49..1,y=-3..46,z=-24..28
        on x=2..47,y=-22..22,z=-23..27
        on x=-27..23,y=-28..26,z=-21..29
        on x=-39..5,y=-6..47,z=-3..44
        on x=-30..21,y=-8..43,z=-13..34
        on x=-22..26,y=-27..20,z=-29..19
        off x=-48..-32,y=26..41,z=-47..-37
        on x=-12..35,y=6..50,z=-50..-2
        off x=-48..-32,y=-32..-16,z=-15..-5
        on x=-18..26,y=-33..15,z=-7..46
        off x=-40..-22,y=-38..-28,z=23..41
        on x=-16..35,y=-41..10,z=-47..6
        off x=-32..-23,y=11..30,z=-14..3
        on x=-49..-5,y=-3..45,z=-29..18
        off x=18..30,y=-20..-8,z=-3..13
        on x=-41..9,y=-7..43,z=-33..15
        on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
        on x=967..23432,y=45373..81175,z=27513..53682
        """
        
        let cubesOn = AOC_2021_Day22.runInternal(stringData: testData, trim: 50)
        print(cubesOn)
        XCTAssertEqual(cubesOn, 590784)
    }
}
