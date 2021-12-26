import Foundation
let start = DispatchTime.now()

//Day16Tests.defaultTestSuite.run()
//Day18Tests.defaultTestSuite.run()
//Day19Tests.defaultTestSuite.run()
//Day20Tests.defaultTestSuite.run()
//Day21Tests.defaultTestSuite.run()
//Day22Tests.defaultTestSuite.run()
Day25Tests.defaultTestSuite.run()


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
//AOC_2021.day15() // part1: 604 / time: 17.4455595 seconds // 5x5 - 2907 / time: 3511s
//AOC_2021_day16.run()
//AOC_2021.day17()
//AOC_2021_day18.run() // 4008
//AOC_2021_day18.runPart2() // 4667
//AOC_2021_Day19.run() // Had to run it on a separate terminal + compile with -O otherwise it took too long: res = 483 // part 2: 14804
//AOC_2021_Day20.run() // 4964 // part2: 13202
//AOC_2021_Day21.run()
//AOC_2021_Day21.runPart2() // 809953813657517 - whoa, memoization is really really powerful
//AOC_2021_Day22.run() // 570915

//AOC_2021_Day24.run()
AOC_2021_Day25.run()


let end = DispatchTime.now()
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
print("Time to evaluate problem: \(timeInterval) seconds")
