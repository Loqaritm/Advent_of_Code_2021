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
                let myStringsOriginal = myStringsOriginalTemp.dropLast()
                var myStrings = myStringsOriginal
                
                // Lets do a big assumption and assume myStrings are all the same length
                let numBits = myStrings[0].count
                print(numBits)
                
                var o2 = 0
                var co2 = 0
                
                for position in 0..<numBits {
                    var positionBit1Count = 0
                    myStrings.forEach { input in
                        positionBit1Count += input[position] == "1" ? 1 : 0
                    }
                    
                    let symbolToKeep: Character = positionBit1Count >= (myStrings.count - positionBit1Count) ? "1" : "0"
                    myStrings.removeAll {
                        $0[position] == symbolToKeep
                    }
                    
                    if myStrings.count == 1 {
                        print("Found it \(myStrings.first!)")
                        o2 = Int(myStrings.first!, radix: 2)!
                        break
                    }
                }
                
                myStrings = myStringsOriginal
                // Shitty code duplication hey ho
                for position in 0..<numBits {
                    var positionBit1Count = 0
                    myStrings.forEach { input in
                        positionBit1Count += input[position] == "1" ? 1 : 0
                    }
                    
                    let symbolToKeep: Character = positionBit1Count < (myStrings.count - positionBit1Count) ? "1" : "0"
                    myStrings.removeAll {
                        $0[position] == symbolToKeep
                    }
                    
                    if myStrings.count == 1 {
                        print("Found it \(myStrings.first!)")
                        co2 = Int(myStrings.first!, radix: 2)!
                        break
                    }
                }
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
