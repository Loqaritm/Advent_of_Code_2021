import Foundation

protocol GeneralPacket {
    
}

extension AOC_2021 {
    public static func day16() {
        struct OperationPacket: GeneralPacket {
            var version: Int
            var type: Int // 6 is operator type
            
            var subPackets: [GeneralPacket] = []
        }
        
        struct ValuePacket: GeneralPacket {
            var version: Int
            var type: Int // 4 is value type
            
            var value: Int
        }
        
        
        if let path = Bundle.main.path(forResource: "input_day16", ofType: "txt") {
            // Remember to drop the newline at the end
            let hexData = try! String(contentsOfFile: path, encoding: .utf8).components(separatedBy: .newlines).dropLast().reduce("", +)
//            let hexData = "A0016C880162017C3686B18A3D4780"
            var binaryData: String = hexData.compactMap{$0.hexToBinary}.reduce("", +)
//            var binaryData = "110100101111111000101000"
            
            var sumOfVersions = 0
            
            func parsePacketData(binaryData: inout String, breakAfterSubpacketNum: Int?, breakAfterSubpacketBits: Int?) -> [GeneralPacket] {
                var returnValue: [GeneralPacket] = []
                var parsedBits = 0
                var parsedPackets = 0
                var shouldBreak = false
                while !shouldBreak {
                    print(binaryData)
                    print(binaryData.count)
                    let version = Int(binaryData.prefix(3), radix: 2)!
                    sumOfVersions += version
                    print("Version: \(version)")
                    binaryData = String(binaryData.dropFirst(3))
                    
                    let type = Int(binaryData.prefix(3), radix: 2)!
                    binaryData = String(binaryData.dropFirst(3))
                    
                    parsedBits += 6
                    
                    switch type {
                    case 4: // Literal value
                        print(binaryData)

                        var firstBitOfValue = ""
                        var readNumber = ""
                        repeat {
                            firstBitOfValue = String(binaryData.prefix(1))
                            readNumber += binaryData[binaryData.index(binaryData.startIndex, offsetBy: 1)..<binaryData.index(binaryData.startIndex, offsetBy: 5)]
                            binaryData = String(binaryData.dropFirst(5))
                            parsedBits += 5
                        } while firstBitOfValue != "0"
                        
                        print("matched literal value")
                        returnValue.append(ValuePacket(version: version, type: 4, value: Int(readNumber, radix: 2)!))
                        
                    default: // Operator packet, reparse
                        print(binaryData)
                        
                        let lengthTypeIdBit = binaryData.prefix(1)
                        binaryData = String(binaryData.dropFirst(1))
                        let lengthTypeBitNumber = lengthTypeIdBit == "0" ? 15 : 11
                        let lengthTypeNumber = Int(binaryData.prefix(lengthTypeBitNumber), radix: 2)!
                        binaryData = String(binaryData.dropFirst(lengthTypeBitNumber))
                        parsedBits += 1 + lengthTypeBitNumber
                        
                        let bitsBefore = binaryData.count
                        if lengthTypeIdBit == "0" {
                            // 0 is num bits
                            print("Found 0, going for breakAfterSubpacketBits: \(lengthTypeNumber)")
                            returnValue.append(contentsOf: parsePacketData(binaryData: &binaryData, breakAfterSubpacketNum: nil, breakAfterSubpacketBits: lengthTypeNumber))
                        } else {
                            // 1 is num packet
                            print("Found 0, going for breakAfterSubpacketNum: \(lengthTypeNumber)")
                            returnValue.append(contentsOf: parsePacketData(binaryData: &binaryData, breakAfterSubpacketNum: lengthTypeNumber, breakAfterSubpacketBits: nil))
                        }
                        let bitsAfter = binaryData.count
                        
                        print("bits after: \(bitsAfter), bits before: \(bitsBefore)")
                        parsedBits += bitsBefore - bitsAfter
                    }
                    
                    parsedPackets += 1
                    
                    print("Parsed packets are: \(parsedPackets), break after is: \(breakAfterSubpacketNum ?? 666)")
                    print("Parsed bits are: \(parsedBits), break after is \(breakAfterSubpacketBits ?? 666)")
                    
                    if breakAfterSubpacketNum != nil && parsedPackets >= breakAfterSubpacketNum! {
                        shouldBreak = true
                    } else if breakAfterSubpacketBits != nil && parsedBits >= breakAfterSubpacketBits! {
                        shouldBreak = true
                    }
                }
//                print("return value is: \(returnValue)")
                return returnValue
            }
            
            let parsed = parsePacketData(binaryData: &binaryData, breakAfterSubpacketNum: 1, breakAfterSubpacketBits: nil)
            print(parsed)
            print("sum of versions: \(sumOfVersions)")
        }
    }
}

extension Character {
    var hexToBinary: String {
//        print("hex: \(self)")
        var binary = String(Int(String(self), radix: 16)!, radix: 2)
//        print("binary: \(binary)")
        if binary.count < 4 {
//            print("dupa: \(binary.count) \(4 - binary.count)")
            binary = String(repeating: "0", count: 4 - binary.count) + binary
        }
//        print("binary dupa: \(binary)")
        return binary
    }
}
