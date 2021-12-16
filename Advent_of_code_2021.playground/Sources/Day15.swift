import Foundation

extension AOC_2021 {
    public static func day15() {
        struct Vertex: Identifiable {
            var id: Int
            
            var weight: Int
            var pathLength: Int = Int.max
            var visited = false
            var nextVertexIds: [Int] = []
        }
        
        if let path = Bundle.main.path(forResource: "input_day15", ofType: "txt") {
            let data = try! String(contentsOfFile: path, encoding: .utf8)
            
            var i = 0
            let tempVertices: [[Vertex]] = Array(0..<2).flatMap{ tileValueOffsetX in
                data.components(separatedBy: .newlines).compactMap { line in
                    if line.isEmpty { return nil }
                    return Array(0..<1).flatMap { tileValueOffsetY in
                        return line.compactMap {
                            i += 1
                            return Vertex(id: i, weight: (Int(String($0))!-1 + tileValueOffsetY + tileValueOffsetX) % 9 + 1)
                        }
                    }
                }
            }
            
            var vertices: [Vertex] = []
            // link all vertices with proper edges
            for i in 0..<tempVertices.count {
                for j in 0..<tempVertices[i].count {
                    var vertexToAppend = tempVertices[i][j]
                    if i < tempVertices.count - 1 {
                        vertexToAppend.nextVertexIds.append(tempVertices[i+1][j].id)
                    }
                    if i > 0 {
                        vertexToAppend.nextVertexIds.append(tempVertices[i-1][j].id)
                    }
                    if j < tempVertices[i].count - 1 {
                        vertexToAppend.nextVertexIds.append(tempVertices[i][j+1].id)
                    }
                    if j > 0 {
                        vertexToAppend.nextVertexIds.append(tempVertices[i][j-1].id)
                    }
                    vertices.append(vertexToAppend)
                }
            }
            
            // Unvisited prepared, now linked with each other
            
            var unvisitedVertices: [Vertex] = []
            vertices[0].pathLength = 0
            unvisitedVertices.append(vertices[0])
            let endVertex = vertices.last!
            
            while !unvisitedVertices.isEmpty {
                // get minimum whole path as current vertex
                let currentVertex = unvisitedVertices.removeFirst()
                print("working on \(currentVertex)")
                vertices = vertices.filter{$0.id != currentVertex.id}
//                vertices.removeAll(where: {$0.id == currentVertex.id})
                if currentVertex.id == endVertex.id {
                    print("Found, distance is: \(currentVertex.pathLength)")
                    return
                }
                
                for nextVertexId in currentVertex.nextVertexIds {
                    if let indexOfTargetVertex = vertices.firstIndex(where: {return $0.id == nextVertexId}) {
                        let distance = currentVertex.pathLength + vertices[indexOfTargetVertex].weight
                        
                        if distance < vertices[indexOfTargetVertex].pathLength {
                            vertices[indexOfTargetVertex].pathLength = distance
                            
                            unvisitedVertices.insert(vertices[indexOfTargetVertex], at: unvisitedVertices.firstIndex(where: {$0.pathLength > vertices[indexOfTargetVertex].pathLength}) ?? unvisitedVertices.endIndex)
                        }
                    }
                }
            }
            print("Haven't reached the destination. This should not happen")
        }
    }
}
