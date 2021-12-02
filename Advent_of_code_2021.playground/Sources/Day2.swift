import Foundation

extension AOC_2021 {
    public static func day2_part1() {
        if let path = Bundle.main.path(forResource: "input_day2", ofType: "txt") {
            do {
                var posX = 0
                var posY = 0
                
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                myStrings.forEach { string in
                    let separated = string.components(separatedBy: " ")
                    if separated.count != 2 {
                        return
                    }
                    
                    let direction = separated[0]
                    let amount = Int(separated[1])!
                    
                    switch direction {
                    case "forward":
                        posX += amount
                    case "up":
                        posY -= amount
                    case "down":
                        posY += amount
                    default:
                        break
                    }
                }
                
                print("posX: \(posX) posY: \(posY) multiplied: \(posX * posY)")
                
            } catch {
                print(error)
            }
        }
    }
    
    public static func day2_part2() {
        if let path = Bundle.main.path(forResource: "input_day2", ofType: "txt") {
            do {
                var posX = 0
                var posY = 0
                var aim = 0
                
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                myStrings.forEach { string in
                    let separated = string.components(separatedBy: " ")
                    if separated.count != 2 {
                        return
                    }
                    
                    let direction = separated[0]
                    let amount = Int(separated[1])!
                    
                    switch direction {
                    case "forward":
                        posX += amount
                        posY += amount * aim
                    case "up":
                        aim -= amount
                    case "down":
                        aim += amount
                    default:
                        break
                    }
                }
                
                print("posX: \(posX) posY: \(posY) multiplied: \(posX * posY)")
                
            } catch {
                print(error)
            }
        }
    }
}
