import Foundation

extension AOC_2021 {
    public static func day9() {
        if let path = Bundle.main.path(forResource: "input_day9", ofType: "txt") {
            let data = try! String(contentsOfFile: path, encoding: .utf8)
            
            let rows = data.components(separatedBy: .newlines)
            func temp(_ row: String) -> [Int]? {
                if row.count == 0 {return nil}
                return row.compactMap{ Int(String($0))! }
            }
            let matrix: [[Int]] = rows.compactMap(temp).pad2DArray(with: Int.max, top: 1, left: 1, right: 1, bottom: 1)
            // Parsed!
            
            func getMiddleIfItsMinimumOf3x3Kernel(kernel: [[Int]]) -> Int? {
                // 3x3 kernel
                let middleValue = kernel[1][1]
                if middleValue < kernel[0][1]
                    && middleValue < kernel[2][1]
                    && middleValue < kernel[1][0]
                    && middleValue < kernel[1][2] {
                    return middleValue
                }
                return nil
            }
            
            func getFreshVisitedMatrix() -> [[Bool]] {
                return Array(repeating: Array(repeating: false, count: matrix.count), count: matrix.count)
            }
            
            let minPosition = 1
            let maxPosition = matrix.count - 2
            // Now to have a recursive basin checking mechanism
            func recursiveGetBasinSize(xPosition: Int, yPosition: Int, visitedMatrix: inout [[Bool]]) -> Int {
                if matrix[xPosition][yPosition] == Int.max
                    || matrix[xPosition][yPosition] == 9
                    || visitedMatrix[xPosition][yPosition] == true {
                    // Don't count and return
                    return 0
                }
                                
                // Mark as visited
                visitedMatrix[xPosition][yPosition] = true
                
                var sizeAtThisPoint = 1
                
                // Check all around
                sizeAtThisPoint += recursiveGetBasinSize(xPosition: xPosition + 1, yPosition: yPosition, visitedMatrix: &visitedMatrix)
                sizeAtThisPoint += recursiveGetBasinSize(xPosition: xPosition, yPosition: yPosition - 1, visitedMatrix: &visitedMatrix)
                sizeAtThisPoint += recursiveGetBasinSize(xPosition: xPosition, yPosition: yPosition + 1, visitedMatrix: &visitedMatrix)
                sizeAtThisPoint += recursiveGetBasinSize(xPosition: xPosition - 1, yPosition: yPosition, visitedMatrix: &visitedMatrix)

                return sizeAtThisPoint
            }
            
            
            var biggestBasinSizes = Array(repeating: 0, count: 3)
            for i in minPosition...maxPosition {
                for j in minPosition...maxPosition {
                    let kernel = matrix[i-1...i+1].map{$0[j-1...j+1].compactMap{$0}}
                    if let _ = getMiddleIfItsMinimumOf3x3Kernel(kernel: kernel) {
                        // Found basin lowest point
                        var visitedMatrix = getFreshVisitedMatrix()
                        let basinSize = recursiveGetBasinSize(xPosition: i, yPosition: j, visitedMatrix: &visitedMatrix)
                        if basinSize > biggestBasinSizes.first! {
                            biggestBasinSizes[0] = basinSize
                            biggestBasinSizes.sort()
                        }
                    }
                }
            }
            
            print("Multiplied sizes is: \(biggestBasinSizes.reduce(1, *))")
        }
    }
}

extension Array where Element: Collection {
    typealias InnerElement = Element.Iterator.Element

    func pad2DArray(with padding: InnerElement,
                    top: Int = 0, left: Int = 0,
                    right: Int = 0, bottom: Int = 0) -> [[InnerElement]] {
        let newHeight = self.count + top + bottom
        let newWidth = (self.first?.count ?? 0) + left + right

        var paddedArray = [[InnerElement]](repeating:
                        [InnerElement](repeating: padding, count: newWidth), count: newHeight)

        for (rowIndex, row) in self.enumerated() {
            for (columnIndex, element) in row.enumerated() {
                paddedArray[rowIndex + top][columnIndex + left] = element
            }
        }

        return paddedArray
    }
}
