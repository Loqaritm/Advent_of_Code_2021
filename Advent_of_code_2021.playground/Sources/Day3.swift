import Foundation

extension AOC_2021 {
    public static func day3() {
        if let path = Bundle.main.path(forResource: "input_day3", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                // Lets do a big assumption and assume myStrings are all the same length
                let numBits = myStrings[0].count
                let numInputs = myStrings.count
                print(numBits)
                
                var gammaRateBits: UInt16 = 0
                
                for position in 0..<numBits {
                    var positionBit1Count = 0
                    myStrings.forEach { input in
                        if (input.count != numBits) {
                            print("Wrong number of bits for line \(input)")
                            return
                        }
                        positionBit1Count += Int(String(input[position]))!
                    }
                    
                    // Shift by one bit
                    gammaRateBits = gammaRateBits << 1
                    // Just add new value to last bit
                    if positionBit1Count >= numInputs - positionBit1Count {
                        // More 1s than 0s
                        gammaRateBits = gammaRateBits | 1
                    }
                }
                // FUCK IT BAD MASK BAD MASK
                let mask: UInt16 = 0b0000111111111111
                let gammaRateInt = Int(gammaRateBits)
                let epsilonRateInt = Int(~gammaRateBits & mask )
                print("Gamma rate is: \(gammaRateInt) epsilon rate is: \(epsilonRateInt) multiplied is: \(gammaRateInt * epsilonRateInt)")
                
            } catch {
                print(error)
            }
        }
    }

    public static func day3_part2() {
        if let path = Bundle.main.path(forResource: "input_day3", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStringsOriginalTemp = data.components(separatedBy: .newlines)
                let myStringsOriginal = Array(myStringsOriginalTemp.dropLast())
                
                func findRating(input: [String], comparisonFunction: (Int, Int) -> Bool) -> Int? {
                    // Lets do a big assumption and assume myStrings are all the same length
                    var inputStrings = input
                    let numBits = input[0].count
                    
                    for position in 0..<numBits {
                        var positionBit1Count = 0
                        inputStrings.forEach {
                            positionBit1Count += $0[position] == "1" ? 1 : 0
                        }
                        
                        let symbolToKeep: Character = comparisonFunction(positionBit1Count, (inputStrings.count - positionBit1Count)) ? "1" : "0"
                        inputStrings.removeAll {
                            $0[position] == symbolToKeep
                        }
                        
                        if inputStrings.count == 1 {
                            return Int(inputStrings.first!, radix: 2)
                        }
                    }
                    return nil
                }
                
                let o2 = findRating(input: myStringsOriginal, comparisonFunction: >=)!
                let co2 = findRating(input: myStringsOriginal, comparisonFunction: <)!
                
                print("o2: \(o2), co2: \(co2), multiplied: \(o2 * co2)")
                
            } catch {
                print(error)
            }
        }
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
