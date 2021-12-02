import Foundation

public struct AOC_2021 {
    public static func day1() -> Void {
//        let path = FileManager.default.currentDirectoryPath
//        let dupaPath = path + "/input.txt"
        
        if let dupaPath = Bundle.main.path(forResource: "input_day1", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: dupaPath, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                let myInts = myStrings.compactMap { Int($0) }
                
                var previousValue: Int = 0
                var count: Int = 0
                var slidingWindow: [Int] = []
                
                myInts.forEach { inputInt in
                    if slidingWindow.count < 3 {
                        slidingWindow.append(inputInt)
                        return
                    } else {
                        slidingWindow.removeFirst()
                        slidingWindow.append(inputInt)
                    }
                    let sum = slidingWindow.reduce(0, +)
                    if sum > previousValue {
                        count += 1
                    }
                    previousValue = sum
                }
                
            //    myStrings.forEach { input in
            //        if let inputInt = Int(input) {
            //            if inputInt > previousValue {
            //                count+=1
            //            }
            //            previousValue = inputInt
            //        }
            //    }
                print("Count is \(count - 1)")
            } catch {
                print(error)
            }
        }
    }
}
