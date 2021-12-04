import Foundation

extension AOC_2021 {
    public struct Board {
        static let boardSize = 5
        
        public struct Field {
            let value: String
            var selected = false
        }
        
        var data: [[Field]]
        
        public mutating func selectNum(selectedValue: String) {
            
            for (n1,c1) in data.enumerated() {
                for (n2, c2) in c1.enumerated() {
                    if c2.value == selectedValue {
                        data[n1][n2].selected = true
                        return
                    }
                }
            }
        }
        
        public var isWinning: Bool {
            let rowWin = data.contains { row in
                row.filter{$0.selected}.count == AOC_2021.Board.boardSize
            }
            if rowWin { return true }
            
            let columnWin = data.transposed().contains { row in
                row.filter{$0.selected}.count == AOC_2021.Board.boardSize
            }
            if columnWin { return true }
            
            return false
        }
        
        public var sumOfNotSelected: Int {
            data.reduce(into: 0) { result, row in
                result += row.reduce(into: 0) { result2, element in
                    if !element.selected {
                        result2 += Int(element.value)!
                    }
                }
            }
        }
    }
    
    public static func day4() {
        if let path = Bundle.main.path(forResource: "input_day4", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines).compactMap {
                    // Remove empty lines
                    $0 != "" ? $0 : nil
                }
                
                // Get first line
                let picks = myStrings[0].components(separatedBy: ",")
                
                var boards: [Board] = []
                
                var helperBoard = Board(data: [[]])
                myStrings[1...].enumerated().forEach { n, c in
                    helperBoard.data.append( c.components(separatedBy: " ").compactMap{
                        // OH YOU FUCKER I THINK IM GONNA SCREAM
                        // The data contains double spaces, so there are some empty values that need
                        // to be removed before we can parse everything properly
                        return $0 != "" ? Board.Field(value: $0) : nil
                    })
                                        
                    if n % Board.boardSize == 4 {
                        // Remove first because it was emptyyy
                        helperBoard.data.removeFirst()
                        // Push new board
                        boards.append(helperBoard)
                        // Replace old helper
                        helperBoard = Board(data: [[]])
                    }
                }
            
                for pick in picks {
                    for (n,_) in boards.enumerated() {
                        boards[n].selectNum(selectedValue: pick)
                        if boards[n].isWinning {
                            print("Board wins! num \(n)")
                            print("Sum of not selected: \(boards[n].sumOfNotSelected)")
                            print("winning pick: \(pick), multiplied result: \(Int(pick)! * boards[n].sumOfNotSelected)")
                            return
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}

extension Collection where Self.Iterator.Element: RandomAccessCollection {
    // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}
