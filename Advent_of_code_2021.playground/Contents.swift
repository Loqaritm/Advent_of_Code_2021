import Foundation
//AOC_2021.day1()
//AOC_2021.day2_part1()
//AOC_2021.day3_part2() // 5852595
//AOC_2021.day4() // 27027 // Part2: 36975
//AOC_2021.day6() // Part2: 1595330616005
//AOC_2021.day7()
//AOC_2021.day8() // 1031553
//AOC_2021.day9() // 458 // Part2: 1391940
//AOC_2021.day10() // part 2: 3042730309
//AOC_2021.day11()
//AOC_2021.day12() // part 2: 114189
//AOC_2021.day13() // part2: RPCKFBLR
//AOC_2021.day14() // part2: 3692219987038
let start = DispatchTime.now()
AOC_2021.day15() // part1: 604 // 68.37s, 2nd try: 17.4455595 seconds /2x1 = 65s /2x2 = 286.165646958 seconds
let end = DispatchTime.now()
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

print("Time to evaluate problem: \(timeInterval) seconds")
