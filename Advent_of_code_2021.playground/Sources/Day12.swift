import Foundation

extension AOC_2021 {
    public static func day12() {
        struct Path {
            var point1: String
            var point2: String
            
            func getNext(point: String) -> String? {
                if point == point1 { return point2 }
                if point == point2 { return point1 }
                return nil
            }
        }
        
        var numOfPaths = 0
        var foundPaths: [[String]] = []
        
        
        func isSmallCave(cave: String) -> Bool {
            cave.filter{$0.isLowercase}.count != 0
        }
        
        func recursiveDfsPath(currentPath: [String], allPaths: [Path], smallCaveAvailableToBeVisitedTwice: String){
            let currentPoint = currentPath.last!
            
            allPaths.forEach {
                if let next = $0.getNext(point: currentPoint)
                    // Either big cave or not yet visited
                    , (!isSmallCave(cave: next) || !currentPath.contains(next)
                    // Or small cave but visited once and we allow to visit it twice
                   || (smallCaveAvailableToBeVisitedTwice == next && currentPath.filter{$0 == next}.count == 1))
                {
                    if next == "end" {
//                        print("Found path! \(currentPath + ["end"])")
                        foundPaths.append(currentPath + ["end"])
                        numOfPaths += 1
                    } else {
                        recursiveDfsPath(currentPath: currentPath + [next], allPaths: allPaths, smallCaveAvailableToBeVisitedTwice: smallCaveAvailableToBeVisitedTwice)
                    }
                }
            }
        }
        
        if let path = Bundle.main.path(forResource: "input_day12", ofType: "txt") {
            let data = try! String(contentsOfFile: path, encoding: .utf8)
//            let data = "start-A\nstart-b\nA-c\nA-b\nb-d\nA-end\nb-end"
            
            var uniqueSmallCaves: [String] = []
            let paths: [Path] = data.components(separatedBy: .newlines).compactMap {
                if $0.count == 0 { return nil }
                
                let components = $0.components(separatedBy: "-")
                if components.count != 2 { return nil }
                
                components.forEach {
                    if isSmallCave(cave: $0) && !uniqueSmallCaves.contains($0) { uniqueSmallCaves.append($0) }
                }
                return Path(point1: components[0], point2: components[1])
            }
                        
            uniqueSmallCaves.removeAll{ $0 == "start" || $0 == "end" }
            uniqueSmallCaves.forEach { uniqueSmallCave in
                print("working on double cave: \(uniqueSmallCave)")
                recursiveDfsPath(currentPath: ["start"], allPaths: paths, smallCaveAvailableToBeVisitedTwice: uniqueSmallCave)
            }
            print("Number of valid paths: \(numOfPaths)")
            
            let uniqueFoundPaths = Array(Set(foundPaths))
            print("Unique found paths number: \(uniqueFoundPaths.count)")

        }
    }
}
