import Foundation

enum PacketType: Int {
    case sum = 0
    case product = 1
    case minimum = 2
    case maximum = 3
    case literal = 4
    case greaterThan = 5
    case lessThan = 6
    case equals = 7
}

protocol GeneralPacket {
    var version: Int {get set}
    var type: PacketType {get set}
    
    var computedContainedValue: Int { get }
}

public struct AOC_2021_day16 {
    private struct OperationPacket: GeneralPacket {
        var version: Int
        var type: PacketType

        var subPackets: [GeneralPacket] = []
        
        var computedContainedValue: Int {
            switch self.type {
            case .sum: return subPackets.reduce(0, {$0 + $1.computedContainedValue})
            case .product: return subPackets.reduce(1, {$0 * $1.computedContainedValue})
            case .minimum: return subPackets.compactMap{$0.computedContainedValue}.min()!
            case .maximum: return subPackets.compactMap{$0.computedContainedValue}.max()!
            case .equals: return subPackets[0].computedContainedValue == subPackets[1].computedContainedValue ? 1 : 0
            case .greaterThan: return subPackets[0].computedContainedValue > subPackets[1].computedContainedValue ? 1 : 0
            case .lessThan: return subPackets[0].computedContainedValue < subPackets[1].computedContainedValue ? 1 : 0
            default:
                print("ERROR: This should never happen!")
                return -1
            }
        }
    }
    private struct ValuePacket: GeneralPacket {
        var version: Int
        var type: PacketType
        var value: Int
        
        var computedContainedValue: Int { value }
    }
    
    private struct BinaryData {
        var index: Int
        var maxIndex: Int { data.count - 1 }
        var data: String
        
        mutating func getBit() -> String {
            let prevIndex = index
            index += 1
            return String(data[prevIndex])
        }
        
        mutating func getNBits(n: Int) -> String {
            return (0..<n).compactMap{_ in getBit() }.reduce("", +)
        }
    }
    
    static private func parseLiteralValue(binaryData: inout BinaryData) -> Int {
        var firstBitOfValue = ""
        var readNumber = ""
        repeat {
            firstBitOfValue = binaryData.getBit()
            readNumber += binaryData.getNBits(n: 4)
        } while firstBitOfValue != "0"
        
        return Int(readNumber, radix: 2)!
    }
    
    // Definitely not ideal functional paradigm - we will be modifying the data here, but this is easiest way
    static private func parsePacketData(binaryData: inout BinaryData, breakAfterSubpacketNum: Int?, breakAfterSubpacketBits: Int?) -> [GeneralPacket] {
        var returnValue: [GeneralPacket] = []
        var parsedPackets = 0
        let indexAtInput = binaryData.index
        while (breakAfterSubpacketNum == nil || parsedPackets < breakAfterSubpacketNum!)
                && (breakAfterSubpacketBits == nil || binaryData.index < indexAtInput + breakAfterSubpacketBits!)
        {
            let version = Int(binaryData.getNBits(n: 3), radix: 2)!
            let type = Int(binaryData.getNBits(n: 3), radix: 2)!

            switch type {
            case 4: // Literal value
                let parsedValue = parseLiteralValue(binaryData: &binaryData)
                returnValue.append(ValuePacket(version: version, type: PacketType(rawValue: 4)!, value: parsedValue))
                
            default: // Operator packet, reparse
                let lengthTypeIdBit = binaryData.getBit()
                if lengthTypeIdBit == "0" {
                    // by num bits
                    let numberToBreakAfter = Int(binaryData.getNBits(n: 15), radix: 2)!
                    let parsedInnerPackets = parsePacketData(binaryData: &binaryData, breakAfterSubpacketNum: nil, breakAfterSubpacketBits: numberToBreakAfter)
                    returnValue.append(OperationPacket(version: version, type: PacketType(rawValue: type)!, subPackets: parsedInnerPackets))
                } else {
                    let numberToBreakAfter = Int(binaryData.getNBits(n: 11), radix: 2)!
                    let parsedInnerPackets = parsePacketData(binaryData: &binaryData, breakAfterSubpacketNum: numberToBreakAfter, breakAfterSubpacketBits: nil)
                    returnValue.append(OperationPacket(version: version, type: PacketType(rawValue: type)!, subPackets: parsedInnerPackets))
                }
            }
            
            parsedPackets += 1
        }
        return returnValue
    }
    
    public static func run() {
        if let path = Bundle.main.path(forResource: "input_day16", ofType: "txt") {
            // Remember to drop the newline at the end
            let stringData = try! String(contentsOfFile: path, encoding: .utf8)
            let computedValue = runInternal(inputData: stringData)
            print("ComputedValue: \(computedValue)")
        }
    }
    
    internal static func runInternal(inputData: String) -> Int {
        let hexData = inputData.components(separatedBy: .newlines).compactMap{$0.isEmpty ? nil : $0}.reduce("", +)
        let binaryDataString: String = hexData.compactMap{$0.hexToBinary}.reduce("", +)
        
        var binaryData = BinaryData(index: 0, data: binaryDataString)
        let parsed = parsePacketData(binaryData: &binaryData, breakAfterSubpacketNum: 1, breakAfterSubpacketBits: nil)
//            print(parsed)
        return parsed[0].computedContainedValue
    }
}

extension Character {
    var hexToBinary: String {
        var binary = String(Int(String(self), radix: 16)!, radix: 2)
        if binary.count < 4 {
            binary = String(repeating: "0", count: 4 - binary.count) + binary
        }
        return binary
    }
}


// MARK: Unit tests
import XCTest

public class Day16Tests: XCTestCase {
    func testDay16() {
        let InputDataDictionary: [String:Int] = ["C200B40A82":3,
                                                 "04005AC33890":54,
                                                 "880086C3E88112":7,
                                                 "CE00C43D881120":9,
                                                 "D8005AC2A8F0":1,
                                                 "F600BC2D8F":0,
                                                 "9C005AC2F8F0":0,
                                                 "9C0141080250320F1802104A08":1]
        InputDataDictionary.forEach { key, value in
            XCTAssertEqual(AOC_2021_day16.runInternal(inputData: key), value)
        }
    }
}
