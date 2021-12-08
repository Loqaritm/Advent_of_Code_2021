import Foundation

extension AOC_2021 {
    public static func day7() {
        if let path = Bundle.main.path(forResource: "input_day7", ofType: "txt") {
            let data = try! String(contentsOfFile: path, encoding: .utf8)
            let crabPositions: [Int] = data.components(separatedBy: ",").compactMap {
                if let value = Int($0.trimmingCharacters(in: .newlines)) {
                    return value
                }
                return nil
            }
            
            let minValue = crabPositions.min()!
            let maxValue = crabPositions.max()!
            
            var minFuelCost = Int.max
            for proposedFinalPosition in minValue...maxValue {
                var currentFuelCost = 0
                for crabPosition in crabPositions {
                    let distance = abs(crabPosition - proposedFinalPosition)
                    currentFuelCost += distance * (1 + distance) / 2
                    if currentFuelCost >= minFuelCost { break } // No point in checking more
                }
                if currentFuelCost < minFuelCost { minFuelCost = currentFuelCost }
            }
            
            print("Minimum fuel cost: \(minFuelCost)")
        }
    }
}
