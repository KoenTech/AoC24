import Foundation

if CommandLine.argc < 2 {
    print("Usage: \(CommandLine.arguments[0]) <input file>");
    exit(1);
}

let fileName = CommandLine.arguments[1];

let input = try! String(contentsOfFile: fileName, encoding: .utf8);

let lines = input.components(separatedBy: CharacterSet.newlines);

var safeCount = 0;

for line in lines {
    let numbers = line.components(separatedBy: CharacterSet.whitespaces).map { str in
        return Int(str)!;
    };

    var last = numbers[0];

    var safeAscending = 1;
    var safeDescending = 1;

    for i in 1..<numbers.count {
        if numbers[i] > last && abs(last - numbers[i]) < 4 {
            safeAscending += 1;
        } else if numbers[i] < last && abs(last - numbers[i]) < 4 {
            safeDescending += 1;
        }
        last = numbers[i];
    }

    if safeAscending == numbers.count || safeDescending == numbers.count {
        safeCount += 1;
    }
}

print("Safe: \(safeCount)");