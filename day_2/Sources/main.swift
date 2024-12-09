import Foundation

if CommandLine.argc < 2 {
    print("Usage: \(CommandLine.arguments[0]) <input file>")
    exit(1)
}

let fileName = CommandLine.arguments[1]

var isPart2 = false
if CommandLine.argc > 2 {
    if CommandLine.arguments[2] == "-p2" {
        isPart2 = true
    }
}

if isPart2 {
    part2()
} else {
    part1()
}

func part1() {
    let input = try! String(contentsOfFile: fileName, encoding: .utf8)

    let lines = input.components(separatedBy: CharacterSet.newlines)

    var safeCount = 0

    for line in lines {
        let numbers = line.components(separatedBy: CharacterSet.whitespaces).map { str in
            return Int(str)!
        }

        var last = numbers[0]

        var safeAscending = 1
        var safeDescending = 1

        for i in 1..<numbers.count {
            if numbers[i] > last && abs(last - numbers[i]) < 4 {
                safeAscending += 1
            } else if numbers[i] < last && abs(last - numbers[i]) < 4 {
                safeDescending += 1
            }
            last = numbers[i]
        }

        if safeAscending == numbers.count || safeDescending == numbers.count {
            safeCount += 1
        }
    }

    print("Safe: \(safeCount)")
}

func part2() {
    let input = try! String(contentsOfFile: fileName, encoding: .utf8)

    let lines = input.components(separatedBy: CharacterSet.newlines)

    var safeCount = 0

    for line in lines {
        let numbers = line.components(separatedBy: CharacterSet.whitespaces).map { str in
            return Int(str)!
        }

        let n = numbers.count
        var closedPairs: [(Int, Int)] = []
        var openPairs: [(Int, Int)] = []

        for i in 0...n-2 {
            closedPairs.append((numbers[i], numbers[i+1]))
            if i < n-2 {
                openPairs.append((numbers[i], numbers[i+2]))
            }
        }

        let signSum = closedPairs.reduce(0) { (acc, pair) in
            if pair.0 == pair.1 {
                return acc
            }
            return acc + ((pair.1 - pair.0)/abs(pair.1 - pair.0))
        }

        let isAscending = signSum >= 0

        var didForgive = false
        var isSafe = true

        var i = 0
        while i <= n-2 {
            let allowed = isAllowed(transition: closedPairs[i], increasing: isAscending)
            if allowed {
                i += 1
                continue
            } else if didForgive {
                isSafe = false
                break
            }
            didForgive = true

            if i == 0 {
                if isAllowed(transition: closedPairs[i+1], increasing: isAscending) || isAllowed(transition: openPairs[i], increasing: isAscending) {
                    i += 1
                } else {
                    isSafe = false
                    break
                }
            } else if i == n-2 {
                break
            } else {
                if isAllowed(transition: openPairs[i], increasing: isAscending) {
                    i += 1
                } else if !isAllowed(transition: openPairs[i-1], increasing: isAscending){
                    isSafe = false
                    break
                }
            }

            i += 1
        }

        safeCount += isSafe ? 1 : 0
    }

    print("Safe: \(safeCount)")
}

func isAllowed(transition: (Int, Int), increasing: Bool) -> Bool {
    let diff = transition.1 - transition.0
    return abs(diff) < 4 && (increasing ? diff > 0 : diff < 0)
}
