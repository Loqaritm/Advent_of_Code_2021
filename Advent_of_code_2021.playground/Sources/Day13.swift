import Foundation

extension AOC_2021 {
    public static func day13() {
        struct Point: Hashable {
            var x: Int
            var y: Int
        }
        
        struct Instruction {
            internal init(alongAxis: String, axisLocation: Int) {
                self.alongAxis = {
                    switch alongAxis {
                    case "x": return AlongAxis.AlongX
                    default: return AlongAxis.AlongY
                    }
                }()
                
                self.axisLocation = axisLocation
            }
            
            enum AlongAxis {
                case AlongX
                case AlongY
            }
            
            var alongAxis: AlongAxis
            var axisLocation: Int
        }
        
        
        if let path = Bundle.main.path(forResource: "input_day13", ofType: "txt") {
            let data = try! String(contentsOfFile: path, encoding: .utf8)
//            let data = "6,10\n0,14\n9,10\n0,3\n10,4\n4,11\n6,0\n6,12\n4,1\n0,13\n10,12\n3,4\n3,0\n8,4\n1,10\n2,14\n8,10\n9,0\n\nfold along y=7\nfold along x=5"
            
            var reachedEndOfPoints = false
            var points: [Point] = []
            var instructions: [Instruction] = []
            
            for line in data.components(separatedBy: .newlines) {
                if !reachedEndOfPoints {
                    if line.isEmpty {
                        reachedEndOfPoints = true
                        continue
                    }
                    let split = line.components(separatedBy: ",")
                    points.append(Point(x: Int(split[0])!, y: Int(split[1])!))
                } else {
                    // instructions
                    if line.isEmpty { continue }
                    let split = line.components(separatedBy: "=")
                    instructions.append(Instruction(alongAxis: String(split[0].last!), axisLocation: Int(split[1])!))
                }
            }
            
            // Parsed
            
            instructions.forEach { instruction in
                if instruction.alongAxis == Instruction.AlongAxis.AlongX {
                    points.indices.forEach{
                        if points[$0].x > instruction.axisLocation {
                            points[$0].x = instruction.axisLocation - (points[$0].x - instruction.axisLocation)
                        }
                    }
                } else {
                    points.indices.forEach{
                        if points[$0].y > instruction.axisLocation {
                            points[$0].y = instruction.axisLocation - (points[$0].y - instruction.axisLocation)
                        }
                    }
                }
                // Remove duplicates
                points = Array(Set(points))
            }
            
            // Now we need to transform this to a matrix and print it out!
            let maxX = points.max(by: {$0.x < $1.x} )!.x + 1
            let maxY = points.max(by: {$0.y < $1.y})!.y + 1
            print(maxX)
            print(maxY)
            
            var matrix = Array(repeating: Array(repeating: " ", count: maxX), count: maxY)
            // I probably could do this much better but there really isn't a point, so let's do it with a O(n2)
            for i in 0..<maxY {
                for j in 0..<maxX {
                    if points.contains(where: {$0.x == j && $0.y == i}) {
                        matrix[i][j] = "#"
                    }
                }
                // Print line by line to make it easier to read
                print(matrix[i].reduce(into: "", {$0 += $1}))
            }
            
        }
    }
}
