import Foundation

extension AOC_2021 {
    public static func day17() {
        // Brute force go brrrrrrr
        
        func getNextPoint(currentPoint: (Int, Int), currentVelocity: (Int, Int)) -> (Int, Int) {
            var retPoints = currentPoint
            if currentVelocity.0 > 0 { retPoints.0 -= currentPoint.0 - 1}
            retPoints.1 = currentPoint.1 - 1
            return retPoints
        }
        
        
        let x1 = 155
        let x2 = 182
        
        let y1 = -117
        let y2 = -67
        
        var highestY = 0
        var countAllMatching = 0
        
        for vx in 0...x2 {
            for vy in y1...(0-y1) {
                var currentVx = vx
                var currentVy = vy
                var currentPoint = (0,0)
                var possibleHighestY = 0
                for _ in 0...500 {
                    currentPoint = (currentPoint.0 + currentVx, currentPoint.1 + currentVy)
                    
                    if currentPoint.1 > possibleHighestY { possibleHighestY = currentPoint.1 }
                    
                    if currentPoint.0 > x2 { break }
                    if currentPoint.1 < y1 { break }
                    
                    if currentPoint.0 >= x1 && currentPoint.0 <= x2 && currentPoint.1 >= y1 && currentPoint.1 <= y2 {
                        // Found
                        if highestY < possibleHighestY {
                            highestY = possibleHighestY
                        }
                        countAllMatching += 1
                        break
                        
                    }

                    if currentVx > 0 { currentVx -= 1 }
                    currentVy -= 1
                }
            }
        }
        
        print(highestY)
        print("all matching: \(countAllMatching)")
        
    }
}
