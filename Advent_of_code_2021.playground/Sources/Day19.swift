import Foundation

public struct AOC_2021_Day19 {
    
    /// The only thing that matters are the differences on each of the respective x y and z positions between probles.
    /// If at least 12 probes have the same differences, we have a match
    /// Because the scanners can be aligned along any axis and the measurements are relative, we need to consider
    /// all possible permutations of a given position - so (x,y,z can become -z,x,-y for example).
    /// Because of that I think the easiest way will be to take scanner 0 as the reference point and go through other scanners
    ///
    /// Probes are overlapping when their x,y,z
    
    struct ProbePosition: Equatable, Hashable, Comparable {
        static func < (lhs: AOC_2021_Day19.ProbePosition, rhs: AOC_2021_Day19.ProbePosition) -> Bool {
            lhs.x < rhs.x
            || lhs.x == rhs.x && lhs.y < rhs.y
            || lhs.x == rhs.x && lhs.x == rhs.y && lhs.z < rhs.z
        }
        
        var x: Int
        var y: Int
        var z: Int
        
        func translated(by: Vector) -> ProbePosition {
            return ProbePosition(x: self.x + by.x, y: self.y + by.y, z: self.z + by.z)
        }
        
        func getTranslation(to: ProbePosition) -> Vector {
            return Vector(x: to.x - self.x, y: to.y - self.y, z: to.z - self.z)
        }
    }
    
    struct Vector: Equatable {
        var x: Int
        var y: Int
        var z: Int
    }
    
    struct Scanner {
        var scannerId: Int
        var probePositions: [ProbePosition]
        var permutationsOfProbePositions: [[ProbePosition]] = []
        
        func getVectorsFromProbeToAllOtherProbes(from: ProbePosition) -> [Vector] {
            probePositions.compactMap {
                Vector(x: $0.x - from.x, y: $0.y - from.y, z: $0.z - from.z)
            }
        }
        
        mutating func addNonOverlappedPoints/*isOverlapped*/(from otherScanner: Scanner) -> Bool {
            // !! For now assume they are in the same coordinate direction
            // A lot of operations, probably could be better but:
            // 1. Get some point
            // 2. Compute the vectors from this point to all others
            // 3. Go through the points of other scanner and check if the vectors produce
            // at least 12 matches from this point
            
            for position in probePositions {
                // Vectors from this point to all others
                let vectors = getVectorsFromProbeToAllOtherProbes(from: position)
                for otherScannerPoint in otherScanner.probePositions {
                    var numberOfMatches = 0
                    for translationVec in vectors {
                        if otherScanner.probePositions.contains(where: {
                            $0 == otherScannerPoint.translated(by: translationVec)
                        }) {
                            print("One matching, \(otherScannerPoint) -->\(translationVec)-->\(otherScannerPoint.translated(by: translationVec))")
                            numberOfMatches += 1
                        }
                    }
                    if numberOfMatches >= 3 {
                        print("Found matching! \(numberOfMatches)")
                        // Meaning that this `otherScannerPoint` is pretty much equal to `position`, just translated
                        let generalTranslation = otherScannerPoint.getTranslation(to: position)
                        print("General translation is \(generalTranslation). PointA: \(position), PointB: \(otherScannerPoint)")
                        
                        var allDetectedProbePositions = self.probePositions
                        otherScanner.probePositions.forEach {
                            print("Adding \($0)-->\(generalTranslation)-->\($0.translated(by: generalTranslation))")
                            allDetectedProbePositions.append($0.translated(by: generalTranslation))
                        }
                        
//                        print("positions before: \(self.probePositions)")
                        self.probePositions = Array(Set(allDetectedProbePositions))
//                        print("positions after \(self.probePositions)")
                        
                        return true
                    }
                }
                
            }
            
            return false
        }
        
    }
    
    public static func run() {
        let stringData = "--- scanner 0 ---"
                        + "\n0,2,0"
                        + "\n4,1,0"
                        + "\n3,3,0"
                        + "\n"
                        + "\n--- scanner 1 ---"
                        + "\n-1,-1,0"
                        + "\n-5,0,0"
                        + "\n-2,1,0"
        
        runInternal(data: stringData)
    }
    
    // Let's skip error handling
    static func parse(stringData: String) -> [Scanner] {
        let scannerStrings = stringData.components(separatedBy: "\n\n")
        let scanners: [Scanner] = scannerStrings.compactMap { scannerString in
            let split = scannerString.components(separatedBy: .newlines)
            let range = split[0].range(of: #"\b[0-9]+\b"#, options: .regularExpression)!
            let scannerId = Int(split[0][range])!
            
            let probePositions: [ProbePosition] = split[1...].compactMap {
                if $0.isEmpty { return nil }
                
                let splitPositions = $0.components(separatedBy: ",").compactMap{ Int($0)! }
                return ProbePosition(x: splitPositions[0], y: splitPositions[1], z: splitPositions[2])
            }
            
            return Scanner(scannerId: scannerId, probePositions: probePositions)
        }
        return scanners
    }
    
    static func runInternal(data: String) {
        let parsedScanners = parse(stringData: data)

    }
    
}










// MARK: Unit tests
import XCTest

public class Day19Tests: XCTestCase {
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
        
        XCTAssertTrue(scanners[0].addNonOverlappedPoints(from: scanners[1]))
        
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
        
        XCTAssertTrue(scanners[0].addNonOverlappedPoints(from: scanners[1]))
        
        // In this case the overlapped points will not add anything
        XCTAssertFalse(scanners[0].probePositions.sorted() == probePositionsBefore.sorted())
        XCTAssertTrue(scanners[0].probePositions.count == 4)
        
        var expectedProbePositions = probePositionsBefore
        expectedProbePositions.append(AOC_2021_Day19.ProbePosition(x: 2, y: 1, z: 1)) // This one is translated to fit probe 0 point of view
        print(scanners[0].probePositions.sorted())
        print(expectedProbePositions.sorted())
        XCTAssertTrue(scanners[0].probePositions.sorted() == expectedProbePositions.sorted())
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
                                                        AOC_2021_Day19.ProbePosition(x: 0, y: 2, z: 0),
                                                        AOC_2021_Day19.ProbePosition(x: 4, y: 1, z: 0),
                                                        AOC_2021_Day19.ProbePosition(x: 3, y: 3, z: 0)
                                                       ]),
                                AOC_2021_Day19.Scanner(scannerId: 1,
                                                       probePositions: [
                                                        AOC_2021_Day19.ProbePosition(x: -1, y: -1, z: 0),
                                                        AOC_2021_Day19.ProbePosition(x: -5, y: 0, z: 0),
                                                        AOC_2021_Day19.ProbePosition(x: -2, y: 1, z: 0)
                                                       ])]
        
        XCTAssert(compareScanners(leftScanner: scanners[0], rightScanner: expectedScanners[0]))
        XCTAssert(compareScanners(leftScanner: scanners[1], rightScanner: expectedScanners[1]))
    }
}

