import Foundation

public struct AOC_2021_day18 {

    class TreeNode {
        var value: Int
        var leftChild: TreeNode?
        var rightChild: TreeNode?
        
        // Node constructor
        init(_ leftChild: TreeNode, _ rightChild: TreeNode) {
            self.value = 0
            self.leftChild = leftChild
            self.rightChild = rightChild
        }
        
        // Leaf constructor
        init(_ value: Int) {
            self.value = value
        }
        
        func addToLeftMost(value: Int) {
            if self.leftChild != nil {
                self.leftChild!.addToLeftMost(value: value)
            } else if self.rightChild != nil {
                self.rightChild!.addToLeftMost(value: value)
            } else {
                self.value += value
            }
        }
        
        func addToRightMost(value: Int) {
            if self.rightChild != nil {
                self.rightChild!.addToRightMost(value: value)
            } else if self.leftChild != nil {
                self.leftChild!.addToRightMost(value: value)
            } else {
                self.value += value
            }
        }
        
        // Returns value that just got exploded
        func traverseAndExplodeIfNecessary(currentDepth: Int) -> (Int?, Int?)? {
            if currentDepth >= 4 {
                if leftChild == nil && rightChild == nil {
                    return nil
                }
                // explode
                let returnValues = (self.leftChild!.value, self.rightChild!.value)
                self.value = 0
                self.leftChild = nil
                self.rightChild = nil
                return returnValues
            }
            
            if let leftChildSafe = self.leftChild, let rightChildSafe = self.rightChild {
                // We're giving biggest priority to left, so start with that one
                if let (addLeft, addRight) = leftChildSafe.traverseAndExplodeIfNecessary(currentDepth: currentDepth + 1) {
                    rightChildSafe.addToLeftMost(value: addRight ?? 0)
                    return (addLeft, nil)
                }
                if let (addLeft, addRight) = rightChildSafe.traverseAndExplodeIfNecessary(currentDepth: currentDepth + 1) {
                    leftChildSafe.addToRightMost(value: addLeft ?? 0)
                    return (nil, addRight)
                }
                return nil
            } else {
//                print("On a leaf, nothing to explode")
                return nil
            }
        }
        
        func traverseAndSplitIfNecessary() -> Bool {
            if let leftChildSafe = leftChild, let rightChildSafe = rightChild {
                if leftChildSafe.traverseAndSplitIfNecessary() { return true }
                if rightChildSafe.traverseAndSplitIfNecessary() { return true }
            } else {
                return splitIfNecessary()
            }
            
            return false
        }
        
        func splitIfNecessary() -> Bool {
            if value > 9 {
                leftChild = TreeNode(Int(floor(Double(value) / 2)))
                rightChild = TreeNode(Int(ceil(Double(value) / 2)))
                value = 0
                return true
            }
            return false
        }
        
        func getMagnitude() -> Int {
            if let leftChildSafe = leftChild, let rightChildSafe = rightChild {
                return 3 * leftChildSafe.getMagnitude() + 2 * rightChildSafe.getMagnitude()
            } else {
                return value
            }
        }
    }
    
    static func parseLine(inputLine: String) -> TreeNode {
        
        if !inputLine.contains(where: {$0 == "," || $0 == "["}) {
            return TreeNode(Int(inputLine)!)
        }
        
        // Strip the "[" and "]" from beggining and end
        let line = String(inputLine.dropFirst().dropLast())
        
        if line[0] != "[" {
            // Meaning it's a raw value, need to find ","
            let commaPos = line.distance(of: ",")!
            return TreeNode(parseLine(inputLine: String(line[0..<commaPos])), parseLine(inputLine: String(line[commaPos+1..<line.count])))
        } else {
            // Find the closing "]" and split based on that
            var openingCharsNum = 0
            for i in 0..<line.count {
                if line[i] == "[" { openingCharsNum += 1 }
                if line[i] == "]" { openingCharsNum -= 1 }
                
                if openingCharsNum == 0 {
                    return TreeNode(parseLine(inputLine: String(line[0..<i+1])), parseLine(inputLine: String(line[i+2..<line.count])))
                }
            }
        }
        
        assertionFailure("Bad data was passed to be parsed")
        return TreeNode(0)
    }
    
    public static func run() {
        // Read data here
        if let path = Bundle.main.path(forResource: "input_day18", ofType: "txt") {
            // Remember to drop the newline at the end
            let stringData = try! String(contentsOfFile: path, encoding: .utf8)
            let treeRoot = runInternal(data: stringData)
            
            print("Reduced tree is: \(treeRoot)")
            let magnitude = treeRoot.getMagnitude()
            print("Magnitude is: \(magnitude)")
        }
    }
    
    public static func runPart2() {
        if let path = Bundle.main.path(forResource: "input_day18", ofType: "txt") {
            let stringData = try! String(contentsOfFile: path, encoding: .utf8)
            let snailfishNumbers = stringData.components(separatedBy: .newlines).compactMap {
                $0.isEmpty ? nil : $0
            }
            
            var maxMagnitude = 0
            for i in 0..<snailfishNumbers.count {
                for j in 0..<snailfishNumbers.count {
                    if i == j { continue }
                    let reducedSum = runInternal(snailfishNumbers: [snailfishNumbers[i], snailfishNumbers[j]])
                    let magnitude = reducedSum.getMagnitude()
                    if magnitude > maxMagnitude { maxMagnitude = magnitude }
                }
            }
            
            print("Max magnitude of summing two different snailfish numbers is: \(maxMagnitude)")
        }
    }
    
    static func runInternal(snailfishNumbers: [String]) -> TreeNode {
        var treeRoot = parseLine(inputLine: snailfishNumbers[0])
            
        for line in snailfishNumbers[1...] {
            treeRoot = TreeNode(treeRoot, parseLine(inputLine: line))
            var shouldBreak = false
            while !shouldBreak {
                while nil != treeRoot.traverseAndExplodeIfNecessary(currentDepth: 0) { /*print("Explosion happened")*/ }
                shouldBreak = !treeRoot.traverseAndSplitIfNecessary()
            }
        }
        
        return treeRoot
    }
    
    static func runInternal(data: String) -> TreeNode {
        let lines = data.components(separatedBy: .newlines).compactMap {
            $0.isEmpty ? nil : $0
        }
        
        return runInternal(snailfishNumbers: lines)
    }
}



// MARK: Extensions
extension AOC_2021_day18.TreeNode: CustomStringConvertible {
    var description: String {
        if leftChild == nil && rightChild == nil {
            return "\(value)"
        } else {
            return "[\(leftChild?.description ?? ""),\(rightChild?.description ?? "")]"
        }
    }
}
extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }

    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }

}
extension StringProtocol {
    func distance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
    func distance<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }
}
extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}
extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}



// MARK: Unit tests
import XCTest

public class Day18Tests: XCTestCase {
    func testDay18() {
        let testData = "[1,1]\n[2,2]\n[3,3]\n[4,4]"
        
        XCTAssertEqual(AOC_2021_day18.runInternal(data: testData).description, "[[[[1,1],[2,2]],[3,3]],[4,4]]")
    }
    
    func testDay18_2() {
        let testData = "[1,1]\n[2,2]\n[3,3]\n[4,4]\n[5,5]"
        
        XCTAssertEqual(AOC_2021_day18.runInternal(data: testData).description, "[[[[3,0],[5,3]],[4,4]],[5,5]]")
    }
    
    func testDay18_parse() {
        let testData = "[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]"
        
        XCTAssertEqual(AOC_2021_day18.parseLine(inputLine: testData).description, testData)
    }
    
    func testDay18_getMagnitude() {
        let testData = "[[1,2],[[3,4],5]]"
        
        let treeRoot = AOC_2021_day18.parseLine(inputLine: testData)
        XCTAssertEqual(treeRoot.getMagnitude(), 143)
    }
    
    func testDay18_runAndGetMagnitude() {
        let testData = "[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]\n"
        + "[[[5,[2,8]],4],[5,[[9,9],0]]]\n"
        + "[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]\n"
        + "[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]\n"
        + "[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]\n"
        + "[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]\n"
        + "[[[[5,4],[7,7]],8],[[8,3],8]]\n"
        + "[[9,3],[[9,9],[6,[4,9]]]]\n"
        + "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]\n"
        + "[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]"
        
        // Check parsing first
        let lines = testData.components(separatedBy: .newlines)
        for line in lines {
            XCTAssertEqual(AOC_2021_day18.parseLine(inputLine: line).description, line)
        }
        
        let treeRoot = AOC_2021_day18.runInternal(data: testData)
        
        XCTAssertEqual(treeRoot.getMagnitude(), 4140)
    }
}
