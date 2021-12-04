import Foundation

//let MaxWidth = 80
//let MaxHeight = 23 // Actually 24, but 24 gets just cut off

let MaxWidth = 66
let MaxHeight = 17

func clearScreen() {
    print("\u{1B}[2J")
}

func drawSymbol(posX: Int, posY: Int) {
//    Works with emoji!
//    let positionAndSymbol = "\u{1B}[\(posX);\(posY)H❤️"
    let symbol: String = {
        switch Int(arc4random_uniform(4)) {
        case 0:
            return "❆"
        case 1:
            return "❆"
        default:
            return "❅"
        }
    }()
    
    let positionAndSymbol = "\u{1B}[\(posX);\(posY)H\(symbol)"

    print(positionAndSymbol)
}

func generateRandomY(numToGenerate: Int) -> [Int] {
    // create an array of 0 through MaxWidth with some step
    var nums = Array(stride(from: 0, to: MaxWidth, by: MaxWidth / MaxWidth))

    var randoms = [Int]()
    for _ in 0..<numToGenerate {
        let index = Int(arc4random_uniform(UInt32(nums.count)))
        randoms.append(nums[index])
        nums.remove(at: index)
    }
    
    return randoms
}

func mainLoop() {
    clearScreen()

    for x in 1...MaxHeight {
        generateRandomY(numToGenerate: 10).forEach {
            drawSymbol(posX: x, posY: $0)
        }
    }
}
                 
repeat {
    mainLoop()
    usleep(500000)
} while true
