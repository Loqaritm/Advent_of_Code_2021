import Foundation

extension AOC_2021 {
    struct Lanternfish {
        var age: Int
    }
    
    public static func day6() {
        if let path = Bundle.main.path(forResource: "input_day6", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
//                let testData = "3,4,3,1,2"
                
                let fishies: [Lanternfish] = data.components(separatedBy: ",").compactMap {
                    if let age = Int($0.trimmingCharacters(in: .newlines)) {
                        return Lanternfish(age: age)
                    }
                    return nil
                }
                
                let reproductionInterval = 6
                // Lets do it like that:
                // There are days of reproduction cycle with the amount of fish in them
                // cycle days are days until the cycle finishes (so they are reversed)
                var cycleDaysWithAmountOfFish = Array(repeating: 0, count: reproductionInterval + 2 + 1)
                
                fishies.forEach{
                    cycleDaysWithAmountOfFish[$0.age] += 1
                }

                let days = 256

                for day in 0..<days {
                    print("Simulating day: \(day)")
                    
                    let amountReproducing = cycleDaysWithAmountOfFish.first!
                    cycleDaysWithAmountOfFish.removeFirst()
                    cycleDaysWithAmountOfFish.append(amountReproducing)
                    cycleDaysWithAmountOfFish[reproductionInterval] += amountReproducing
                }
                
                let lanternFishCount = cycleDaysWithAmountOfFish.reduce(0, +)
                print("Lanternfish count: \(lanternFishCount)")
                
                
            } catch {
                print(error)
            }
        }
    }
}
