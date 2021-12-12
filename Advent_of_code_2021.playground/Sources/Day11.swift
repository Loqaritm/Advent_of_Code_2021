import Foundation

extension AOC_2021 {
    public static func day11() {
        if let path = Bundle.main.path(forResource: "input_day11", ofType: "txt") {
            let data = try! String(contentsOfFile: path, encoding: .utf8)
            
            let lines: [String] = data.components(separatedBy: .newlines).compactMap {
                if $0.count == 0 { return nil }
                return $0
            }
            
            var dumboOctopusMatrix: [[Int]] = lines.compactMap {
                $0.compactMap{ Int(String($0))! }
            }
            
            // Pad to simplify operations
            dumboOctopusMatrix = dumboOctopusMatrix.pad2DArray(with: 0, top: 1, left: 1, right: 1, bottom: 1)

            var flashAmount = 0
            
            func recursiveFlashIfNeeded(positionX: Int, postiionY: Int, matrix: inout [[Int]]) {
                if matrix[positionX][postiionY] > 9 {
                    // Flash!
                    matrix[positionX][postiionY] = 0
                    flashAmount += 1
                    
                    // Increase all around
                    // Helper function to make it a bit easier
                    func increaseAndCallRecursiveFlash(positionX: Int, positionY: Int, matrix: inout [[Int]]) {
                        // Ignore when it already flashed
                        if matrix[positionX][positionY] == 0 { return }
                        matrix[positionX][positionY] += 1
                        recursiveFlashIfNeeded(positionX: positionX, postiionY: positionY, matrix: &matrix)
                    }
                    
                    increaseAndCallRecursiveFlash(positionX: positionX-1, positionY: postiionY-1, matrix: &matrix)
                    increaseAndCallRecursiveFlash(positionX: positionX-1, positionY: postiionY, matrix: &matrix)
                    increaseAndCallRecursiveFlash(positionX: positionX-1, positionY: postiionY+1, matrix: &matrix)
                    increaseAndCallRecursiveFlash(positionX: positionX, positionY: postiionY-1, matrix: &matrix)
                    increaseAndCallRecursiveFlash(positionX: positionX, positionY: postiionY+1, matrix: &matrix)
                    increaseAndCallRecursiveFlash(positionX: positionX+1, positionY: postiionY-1, matrix: &matrix)
                    increaseAndCallRecursiveFlash(positionX: positionX+1, positionY: postiionY, matrix: &matrix)
                    increaseAndCallRecursiveFlash(positionX: positionX+1, positionY: postiionY+1, matrix: &matrix)

                }
            }
            
            func areAllFlashed() -> Bool {
                return dumboOctopusMatrix.reduce(0, { $0 + $1.reduce(0, +)} ) == 0
            }
            
            let NUM_STEPS = 1000
            
            for i in 0..<NUM_STEPS {
                // First, increase each by one
                dumboOctopusMatrix[1..<dumboOctopusMatrix.count - 1].enumerated().forEach { (n,c) in
                    c[1..<c.count - 1].indices.forEach{ dumboOctopusMatrix[n + 1][$0] += 1}
                }

                dumboOctopusMatrix[1..<dumboOctopusMatrix.count - 1].enumerated().forEach { (n,c) in
                    c[1..<c.count - 1].indices.forEach{ recursiveFlashIfNeeded(positionX: n + 1, postiionY: $0, matrix: &dumboOctopusMatrix)}
                }
                
                // Part 2
                if areAllFlashed() {
                    print("All flashed on step \(i+1)")
                    return
                }
            }
            
            print("Flashes number: \(flashAmount)")
        }
    }
}
