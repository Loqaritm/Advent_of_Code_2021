import Foundation

extension AOC_2021 {
    
    public struct Line {
        public struct Point {
            var x: Int
            var y: Int
        }
        
        var startPoint: Point
        var endPoint: Point
    }
    
    
    public static func day5() {
        if let path = Bundle.main.path(forResource: "input_day5", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                var maxX = 0
                var maxY = 0
                let lines: [Line] = data.components(separatedBy: .newlines).compactMap {
                    // Ignore empty lines
                    if $0 == "" {return nil}
                                        
                    let points: [Line.Point] = $0.components(separatedBy: " -> ").compactMap { point in
                        let coords = point.components(separatedBy: ",")
                        maxX = max(maxX, Int(coords[0])!)
                        maxY = max(maxY, Int(coords[1])!)
                        return Line.Point(x: Int(coords[0])!, y: Int(coords[1])!)
                    }
                    return Line(startPoint: points[0], endPoint: points[1])
                }
                
                // Parsing done!
                
                print(lines[0])
                print(lines[1])
                                
                print("maxX: \(maxX) maxY: \(maxY)")
                
                // X will be horizontal, Y vertical
                // Create matrix of zeroes
                var matrix = Array(repeating: Array(repeating: 0, count: maxY+1), count: maxX+1)
                
                lines.forEach{ line in
                    if line.startPoint.y == line.endPoint.y {
                        // Horizontal
                        let localMinX = min(line.startPoint.x, line.endPoint.x)
                        let localMaxX = max(line.startPoint.x, line.endPoint.x)

                        for localX in localMinX...localMaxX {
                            matrix[localX][line.startPoint.y] += 1
                        }
                    } else if line.startPoint.x == line.endPoint.x {
                        // Vertical
                        let localMinY = min(line.startPoint.y, line.endPoint.y)
                        let localMaxY = max(line.startPoint.y, line.endPoint.y)
                        
                        for localY in localMinY...localMaxY {
                            matrix[line.startPoint.x][localY] += 1
                        }
                    } else {
                        let higherPoint = line.startPoint.x < line.endPoint.x ? line.startPoint : line.endPoint
                        let lowerPoint = line.startPoint.x >= line.endPoint.x ? line.startPoint : line.endPoint
                        
                        var goingRight = true
                        if higherPoint.y < lowerPoint.y {
                            // Means we're going right as we go down
                            goingRight = true
                        } else {
                            // means we're going left as we go down
                            goingRight = false
                        }
                        
                        // We'll always draw from top to bottom this way. But we need to know if y increases or decreases on the way down
                        
                        
                        // no need to compute minY because it will always be 45 deg, so same length here and here
                        
                        for localX in higherPoint.x...lowerPoint.x {
                            let localY = goingRight ? higherPoint.y + (localX - higherPoint.x) : higherPoint.y - (localX - higherPoint.x)
                            matrix[localX][localY] += 1
                        }
                    }
                }
                                
                var totalIntersections = 0
                matrix.forEach {
                    $0.forEach {
                        if $0 >= 2 {
                            totalIntersections += 1
                        }
                    }
                }
                
                print("Total intersections: \(totalIntersections)")
                
            } catch {
                print(error)
            }
        }
    }
}
