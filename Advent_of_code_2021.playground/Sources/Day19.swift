import Foundation

public struct AOC_2021_Day19 {
    
    /// The general idea behind this solution is this:
    /// 1. We generate all possible permutations of probe positions per scanner (in all possible 24 coordinate spaces)
    /// 2. We iterate over the probes in a given permutation of an lhs scanner and:
    ///     1. Compute all distance vectors between this point and all other points of lhs scanner
    ///     2. Use this distance to iterate over all other points in the rhs and check if the positions it produces represent probes
    ///     3. Repeat for another point if we haven't gotten 12 matches
    
    struct Position3D: Equatable, Hashable, Comparable {
        static func < (lhs: AOC_2021_Day19.Position3D, rhs: AOC_2021_Day19.Position3D) -> Bool {
            lhs.x < rhs.x
            || lhs.x == rhs.x && lhs.y < rhs.y
            || lhs.x == rhs.x && lhs.x == rhs.y && lhs.z < rhs.z
        }
        
        var x: Int // Arbitrarily this is forward
        var y: Int // Arbitrarily this is up
        var z: Int // Arbitrarily this is right
        
        func translated(by: Vector) -> Position3D {
            return Position3D(x: self.x + by.x, y: self.y + by.y, z: self.z + by.z)
        }
        
        func getTranslation(to: Position3D) -> Vector {
            return Vector(x: to.x - self.x, y: to.y - self.y, z: to.z - self.z)
        }
        
        func rotatedAroundX() -> Position3D {
            return Position3D(x: self.x, y: -self.z , z: self.y)
        }
        
        func rotatedAroundY() -> Position3D {
            return Position3D(x: -self.z, y: self.y, z: self.x)
        }
        
        func rotatedAroundZ() -> Position3D {
            return Position3D(x: self.y, y: -self.x, z: self.z)
        }
    }
    
    struct Vector: Equatable {
        var x: Int
        var y: Int
        var z: Int
    }
    
    struct Scanner {
        var scannerId: Int
        var probePositions: [Position3D]
        var permutationsOfProbePositions: [[Position3D]] = []
        
        // Assume only Scanner 0 is in ocean coordinates - it will be our point of reference
        var positionInOceanCoords = Position3D(x: 0, y: 0, z: 0)
        
        init(scannerId: Int, probePositions: [Position3D]) {
            self.scannerId = scannerId
            self.probePositions = probePositions
            
            self.permutationsOfProbePositions = getAllPermutationsOfProbes()
        }
        
        // We need to generate all possible permutations, because we will be comparing all Scanners
        // in the Scanner 0 coordinate space (one of the possible 24 spaces)
        func getAllPermutationsOfProbes() -> [[Position3D]] {
            // 3 axis as forward, 2 directions, 4 rotation positions = 24 permutations
            
            // Start with original data
            var operatedOn = probePositions
            var returnPermutations: [[Position3D]] = []
            
            for _ in 0..<4 {
                for _ in 0..<4 { // Turn 4 times
                    returnPermutations.append(operatedOn)
                    operatedOn = operatedOn.compactMap{$0.rotatedAroundX()}
                }
                // Turn around Y axis and repeat
                operatedOn = operatedOn.compactMap{$0.rotatedAroundY()}
            }
            
            // We should be back in original position now
            operatedOn = operatedOn.compactMap{$0.rotatedAroundZ()}
            for _ in 0..<4 { // Turn 4 times
                returnPermutations.append(operatedOn)
                operatedOn = operatedOn.compactMap{$0.rotatedAroundX()}
            }
            
            // Turn two times around Z (so basically we flip)
            operatedOn = operatedOn.compactMap{$0.rotatedAroundZ().rotatedAroundZ()}
            for _ in 0..<4 { // Turn 4 times
                returnPermutations.append(operatedOn)
                operatedOn = operatedOn.compactMap{$0.rotatedAroundX()}
            }
            
            return returnPermutations
        }
        
        func getVectorsFromProbeToAllOtherProbes(from: Position3D) -> [Vector] {
            probePositions.compactMap {
                Vector(x: $0.x - from.x, y: $0.y - from.y, z: $0.z - from.z)
            }
        }
        
        mutating func addNonOverlappedPointsAndReturnTranslatedOtherScannerCoords(from otherScanner: Scanner, neededMatches: Int) -> Position3D? {
            // This just needs to be a random position to pivot off of (so it has to be in both scanners)
            for position in probePositions {
                // Vectors from this point to all others
                let vectors = getVectorsFromProbeToAllOtherProbes(from: position)
                for otherProbePositions in otherScanner.permutationsOfProbePositions {
                    for otherScannerPoint in otherProbePositions {
                        var numberOfMatches = 0
                        for (n,translationVec) in vectors.enumerated() {
                            if neededMatches - numberOfMatches > vectors.count - n { break }
                            if otherProbePositions.contains(where: {
                                $0 == otherScannerPoint.translated(by: translationVec)
                            }) {
                                numberOfMatches += 1
                                
                                if numberOfMatches >= neededMatches {
                                    // Meaning that this `otherScannerPoint` is pretty much equal to `position`, just translated
                                    let generalTranslation = otherScannerPoint.getTranslation(to: position)
                                    print("General translation is \(generalTranslation). PointA: \(position), PointB: \(otherScannerPoint)")
                                    
                                    var allDetectedProbePositions = self.probePositions
                                    otherProbePositions.forEach {
                                        allDetectedProbePositions.append($0.translated(by: generalTranslation))
                                    }
                                    
                                    self.probePositions = Array(Set(allDetectedProbePositions))
                                    self.permutationsOfProbePositions = getAllPermutationsOfProbes()
                                    
//                                    print("New number of probes seen by scanner \(scannerId) is: \(self.probePositions.count)")
                                    
                                    // Now we need to compute the other scanner's position in this coordinate space
                                    return otherScanner.positionInOceanCoords.translated(by: generalTranslation)
                                }
                            }
                        }
                    }
                }
            }
            return nil
        }
        
    }
    
    public static func run() {
        if let path = Bundle.main.path(forResource: "input_day19", ofType: "txt") {
            let stringData = try! String(contentsOfFile: path, encoding: .utf8)
            let countOfAllPointsFrom0Perspective = AOC_2021_Day19.runInternal(data: stringData)
            print("Count of all points from perspective of 0 is: \(countOfAllPointsFrom0Perspective)")
        }
    }
    
    // Let's skip error handling
    static func parse(stringData: String) -> [Scanner] {
        let scannerStrings = stringData.components(separatedBy: "\n\n")
        let scanners: [Scanner] = scannerStrings.compactMap { scannerString in
            let split = scannerString.components(separatedBy: .newlines)
            let range = split[0].range(of: #"\b[0-9]+\b"#, options: .regularExpression)!
            let scannerId = Int(split[0][range])!
            
            let probePositions: [Position3D] = split[1...].compactMap {
                if $0.isEmpty { return nil }
                
                let splitPositions = $0.components(separatedBy: ",").compactMap{ Int($0)! }
                return Position3D(x: splitPositions[0], y: splitPositions[1], z: splitPositions[2])
            }
            
            return Scanner(scannerId: scannerId, probePositions: probePositions)
        }
        return scanners
    }
    
    static func runInternal(data: String) -> Int {
        var parsedScanners = parse(stringData: data)
        
        var otherScannersInOceanCoords: [Position3D] = []
        var i = 1
        while parsedScanners.count != 1 {
            print("Scanners yet to parse: \(parsedScanners.count)")
            if let positionOfOtherScanner = parsedScanners[0].addNonOverlappedPointsAndReturnTranslatedOtherScannerCoords(from: parsedScanners[i], neededMatches: 12) {
                otherScannersInOceanCoords.append(positionOfOtherScanner)
                parsedScanners.remove(at: i)
                i = 1
            } else {
                i += 1
            }
        }
        
//        return parsedScanners[0].probePositions.count
        
        // Part2:
        func getManhattanDistance(lhs: Position3D, rhs: Position3D) -> Int {
            return abs(lhs.x - rhs.x) + abs(lhs.y - rhs.y) + abs(lhs.z - rhs.z)
        }
        
        var maxManhattanDistance = 0
        otherScannersInOceanCoords.forEach { outer in
            otherScannersInOceanCoords.forEach { inner in
                let manhattanDistance = getManhattanDistance(lhs: outer, rhs: inner)
                if manhattanDistance > maxManhattanDistance { maxManhattanDistance = manhattanDistance }
            }
        }
        
        
        return maxManhattanDistance
    }
    
}










// MARK: Unit tests
import XCTest

public class Day19Tests: XCTestCase {
    func testDay19_getAllPermutationsOfProbes() {
        let stringData = """
        --- scanner 0 ---
        -1,-1,1
        -2,-2,2
        -3,-3,3
        -2,-3,1
        5,6,-4
        8,0,7

        --- scanner 0 ---
        1,-1,1
        2,-2,2
        3,-3,3
        2,-1,3
        -5,4,-6
        -8,-7,0

        --- scanner 0 ---
        -1,-1,-1
        -2,-2,-2
        -3,-3,-3
        -1,-3,-2
        4,6,5
        -7,0,8

        --- scanner 0 ---
        1,1,-1
        2,2,-2
        3,3,-3
        1,3,-2
        -4,-6,5
        7,0,8

        --- scanner 0 ---
        1,1,1
        2,2,2
        3,3,3
        3,1,2
        -6,-4,-5
        0,7,-8
        """
        
        let scanners = AOC_2021_Day19.parse(stringData: stringData)
        let allPermutations = scanners[0].getAllPermutationsOfProbes()
        
        XCTAssertTrue(allPermutations.count == 24)
        
        // Make sure they're all unique
        XCTAssertTrue(Set(allPermutations).count == 24)
        
        let allPermutationsSorted = allPermutations.compactMap{$0.sorted()}
        
        // Now check that those are actually there as expected
        scanners[1...].forEach {
            XCTAssertTrue(allPermutationsSorted.contains($0.probePositions.sorted()))
        }
    }
    
    func testDay19_addNonOverlappedPoints_allOverlap() {
        let stringData = "--- scanner 0 ---"
                        + "\n0,2,0"
                        + "\n4,1,0"
                        + "\n3,3,0"
                        + "\n"
                        + "\n--- scanner 1 ---"
                        + "\n-1,-1,0"
                        + "\n-5,0,0"
                        + "\n-2,1,0"
                        + "\n"
        
        var scanners = AOC_2021_Day19.parse(stringData: stringData)
        let probePositionsBefore = scanners[0].probePositions
        
        XCTAssertNotNil(scanners[0].addNonOverlappedPointsAndReturnTranslatedOtherScannerCoords(from: scanners[1], neededMatches: 3))
        
        // In this case the overlapped points will not add anything
        XCTAssertTrue(scanners[0].probePositions.sorted() == probePositionsBefore.sorted())
    }
    
    func testDay19_addNonOverlappedPoints_notAllOverlap() {
        let stringData = "--- scanner 0 ---"
                        + "\n0,2,0"
                        + "\n4,1,0"
                        + "\n3,3,0"
                        + "\n"
                        + "\n--- scanner 1 ---"
                        + "\n-1,-1,0"
                        + "\n-5,0,0"
                        + "\n-2,1,0"
                        + "\n-3,-1,1"
                        + "\n"
        
        var scanners = AOC_2021_Day19.parse(stringData: stringData)
        let probePositionsBefore = scanners[0].probePositions
        
        XCTAssertNotNil(scanners[0].addNonOverlappedPointsAndReturnTranslatedOtherScannerCoords(from: scanners[1], neededMatches: 3))
        
        // In this case the overlapped points will not add anything
        XCTAssertFalse(scanners[0].probePositions.sorted() == probePositionsBefore.sorted())
        XCTAssertTrue(scanners[0].probePositions.count == 4)
        
        var expectedProbePositions = probePositionsBefore
        expectedProbePositions.append(AOC_2021_Day19.Position3D(x: 2, y: 1, z: 1)) // This one is translated to fit probe 0 point of view
        XCTAssertTrue(scanners[0].probePositions.sorted() == expectedProbePositions.sorted())
    }
    
    func testDay19_addNonOverlappedPoints_differentCoordSpaces() {
        let stringData = """
        --- scanner 0 ---
        404,-588,-901
        528,-643,409
        -838,591,734
        390,-675,-793
        -537,-823,-458
        -485,-357,347
        -345,-311,381
        -661,-816,-575
        -876,649,763
        -618,-824,-621
        553,345,-567
        474,580,667
        -447,-329,318
        -584,868,-557
        544,-627,-890
        564,392,-477
        455,729,728
        -892,524,684
        -689,845,-530
        423,-701,434
        7,-33,-71
        630,319,-379
        443,580,662
        -789,900,-551
        459,-707,401

        --- scanner 1 ---
        686,422,578
        605,423,415
        515,917,-361
        -336,658,858
        95,138,22
        -476,619,847
        -340,-569,-846
        567,-361,727
        -460,603,-452
        669,-402,600
        729,430,532
        -500,-761,534
        -322,571,750
        -466,-666,-811
        -429,-592,574
        -355,545,-477
        703,-491,-529
        -328,-685,520
        413,935,-424
        -391,539,-444
        586,-435,557
        -364,-763,-893
        807,-499,-711
        755,-354,-619
        553,889,-390
        """
        
//        let expectedStringData = """
//        -618,-824,-621
//        -537,-823,-458
//        -447,-329,318
//        404,-588,-901
//        544,-627,-890
//        528,-643,409
//        -661,-816,-575
//        390,-675,-793
//        423,-701,434
//        -345,-311,381
//        459,-707,401
//        -485,-357,347
//        """
        
//        let expectedOverlappedProbes: [AOC_2021_Day19.ProbePosition] = expectedStringData.components(separatedBy: .newlines).compactMap{
//            let split = $0.components(separatedBy: ",").compactMap{Int($0)!}
//            return AOC_2021_Day19.ProbePosition(x: split[0], y: split[1], z: split[2])
//        }
        
        var scanners = AOC_2021_Day19.parse(stringData: stringData)
        
        XCTAssertNotNil(scanners[0].addNonOverlappedPointsAndReturnTranslatedOtherScannerCoords(from: scanners[1], neededMatches: 12))
    }
    
    func testDay19_addNonOverlappedPoints_differentCoordSpaces_multipleScanners() {
        if let path = Bundle.main.path(forResource: "input_day19_test", ofType: "txt") {
            let stringData = try! String(contentsOfFile: path, encoding: .utf8)
            let countOfAllPointsFrom0Perspective = AOC_2021_Day19.runInternal(data: stringData)
            print("Count of all points from perspective of 0 is: \(countOfAllPointsFrom0Perspective)")
            
            // Part 1
//            XCTAssertEqual(countOfAllPointsFrom0Perspective, 79)
        }
    }
    
    func testDay19_parse() {
        let stringData = "--- scanner 0 ---"
                        + "\n0,2,0"
                        + "\n4,1,0"
                        + "\n3,3,0"
                        + "\n"
                        + "\n--- scanner 1 ---"
                        + "\n-1,-1,0"
                        + "\n-5,0,0"
                        + "\n-2,1,0"
                        + "\n"
        
        let scanners = AOC_2021_Day19.parse(stringData: stringData)
        
        func compareScanners(leftScanner: AOC_2021_Day19.Scanner, rightScanner: AOC_2021_Day19.Scanner) -> Bool {
            return leftScanner.scannerId == rightScanner.scannerId
            && leftScanner.probePositions.count == rightScanner.probePositions.count
            && leftScanner.probePositions.enumerated().compactMap{(n,x) in
                return x == rightScanner.probePositions[n] ? 1 : nil
            }.count == leftScanner.probePositions.count
        }
        
        XCTAssertEqual(scanners.count, 2)
        let expectedScanners = [AOC_2021_Day19.Scanner(scannerId: 0,
                                                       probePositions: [
                                                        AOC_2021_Day19.Position3D(x: 0, y: 2, z: 0),
                                                        AOC_2021_Day19.Position3D(x: 4, y: 1, z: 0),
                                                        AOC_2021_Day19.Position3D(x: 3, y: 3, z: 0)
                                                       ]),
                                AOC_2021_Day19.Scanner(scannerId: 1,
                                                       probePositions: [
                                                        AOC_2021_Day19.Position3D(x: -1, y: -1, z: 0),
                                                        AOC_2021_Day19.Position3D(x: -5, y: 0, z: 0),
                                                        AOC_2021_Day19.Position3D(x: -2, y: 1, z: 0)
                                                       ])]
        
        XCTAssert(compareScanners(leftScanner: scanners[0], rightScanner: expectedScanners[0]))
        XCTAssert(compareScanners(leftScanner: scanners[1], rightScanner: expectedScanners[1]))
    }
}

