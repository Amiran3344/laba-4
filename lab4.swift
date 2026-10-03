import Foundation
// Лабораторная работа №4
// Функции, замыкания, map/filter/reduce
// A. power
func power(base: Int, exponent: Int = 2) -> Int {
    if exponent == 0 { return 1 }
    if exponent < 0 { return 0 } // Int не поддерживает дробные степени
    var result = 1
    for _ in 0..<exponent { result *= base }
    return result
}
print(power(base: 3))
print(power(base: 2, exponent: 10))
print(power(base: 5, exponent: 3))
print(power(base: 2, exponent: -1)) // 0

//  B. Метки аргументов 
func greet(_ person: String, from hometown: String) -> String {
    return "Привет, \(person)! Рады видеть гостя из \(hometown)."
}
func move(from start: String, to end: String) -> String {
    return "Перемещение из \(start) в \(end)"
}
func repeatText(_ text: String, times count: Int) -> String {
    return Array(repeating: text, count: count).joined(separator: " ")
}
print(greet("Иван", from: "Москва"))
print(move(from: "A", to: "B"))
print(repeatText("Swift", times: 3))

//  C. Вариативные параметры 
func joinStrings(_ strings: String..., separator: String = ", ") -> String {
    return strings.joined(separator: separator)
}
print(joinStrings("Swift", "Python", "Go"))
print(joinStrings("a", "b", "c", separator: " - "))
print(joinStrings("Один"))

func sum(_ numbers: Int...) -> Int {
    return numbers.reduce(0, +)
}
print(sum(1, 2, 3, 4, 5))

// D. inout 
func swapValues(_ a: inout Int, _ b: inout Int) {
    let temp = a; a = b; b = temp
}
var x = 10, y = 20
swapValues(&x, &y)
print("x=\(x), y=\(y)")

func clamp(_ value: inout Int, min: Int, max: Int) {
    if value < min { value = min }
    if value > max { value = max }
}
var val = 150
clamp(&val, min: 0, max: 100)
print(val)

func normalize(_ array: inout [Double]) {
    guard let mx = array.max(), mx != 0 else { return }
    for i in 0..<array.count { array[i] /= mx }
}
var data = [2.0, 4.0, 6.0, 8.0, 10.0]
normalize(&data)
print(data)

// E. Функции как объекты первого класса
func add(_ a: Int, _ b: Int) -> Int { return a + b }
func multiply(_ a: Int, _ b: Int) -> Int { return a * b }
func subtract(_ a: Int, _ b: Int) -> Int { return a - b }
func divide(_ a: Int, _ b: Int) -> Int { return b != 0 ? a / b : 0 }

func applyOperation(_ a: Int, _ b: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(a, b)
}
print(applyOperation(5, 3, operation: add))
print(applyOperation(5, 3, operation: multiply))

let operations: [(Int, Int) -> Int] = [add, multiply, subtract, divide]
for op in operations {
    print(applyOperation(12, 4, operation: op))
}

func applyToEach(_ array: inout [Int], transform: (Int) -> Int) {
    for i in 0..<array.count { array[i] = transform(array[i]) }
}
var nums = [1, 2, 3, 4, 5]
applyToEach(&nums) { $0 * $0 }
print(nums)
applyToEach(&nums) { $0 + 10 }
print(nums)

//  F. Фабрика замыканий 
func makeMultiplier(factor: Int) -> (Int) -> Int {
    return { $0 * factor }
}
let double = makeMultiplier(factor: 2)
let triple = makeMultiplier(factor: 3)
print(double(5), triple(7), triple(10))

func makeAdder(value: Int) -> (Int) -> Int {
    return { $0 + value }
}
let addTen = makeAdder(value: 10)
print(addTen(5))

func makeFormatter(prefix: String, suffix: String) -> (String) -> String {
    return { "\(prefix)\($0)\(suffix)" }
}
let bracket = makeFormatter(prefix: "[", suffix: "]")
print(bracket("hello"))

//  G. Этапы сокращения замыкания
let numbers = [5, 2, 8, 1, 9, 3]
let s1 = numbers.sorted(by: { (a: Int, b: Int) -> Bool in return a > b })
let s2 = numbers.sorted(by: { a, b in return a > b })
let s3 = numbers.sorted(by: { a, b in a > b })
let s4 = numbers.sorted(by: { $0 > $1 })
let s5 = numbers.sorted { $0 > $1 }
print(s1, s2, s3, s4, s5)

//  H. Функциональные цепочки 
let result = (1...20).filter { $0 % 3 == 0 }.map { $0 * $0 }.reduce(0, +)
print(result)

let words = ["hello", "world", "swift", "is", "great"]
let sentence = words.filter { $0.count > 4 }.map { $0.uppercased() }.joined(separator: " ")
print(sentence)

let mixed = [1, -2, 3, -4, 5, -6]
let product = mixed.filter { $0 > 0 }.map { $0 * 2 }.reduce(1, *)
print(product)

typealias Student = (name: String, grade: Double)
let students: [Student] = [
    ("Анна", 4.8), ("Борис", 3.2), ("Вера", 4.5), ("Глеб", 2.9),
    ("Дарья", 3.8), ("Егор", 4.1), ("Жанна", 4.9), ("Захар", 3.5)
]

let top = students.filter { $0.grade >= 4.5 }.sorted { $0.grade > $1.grade }
print("Отличники: " + top.map { "\($0.name) (\($0.grade))" }.joined(separator: ", "))

let avg = students.map { $0.grade }.reduce(0, +) / Double(students.count)
print("Средний балл: \(avg)")

print("Все студенты: " + students.map { $0.name }.joined(separator: ", "))
print("Студентов с баллом < 3.5: \(students.filter { $0.grade < 3.5 }.count)")

//  I. Конвейер 
typealias Transform = (String) -> String

func trimWhitespace(_ s: String) -> String {
    return s.trimmingCharacters(in: .whitespaces)
}
func lowercase(_ s: String) -> String { return s.lowercased() }
func removeDigits(_ s: String) -> String { return s.filter { !$0.isNumber } }
func replaceSpaces(with char: String) -> Transform {
    return { $0.replacingOccurrences(of: " ", with: char) }
}

func pipeline(_ input: String, transforms: [Transform]) -> String {
    var result = input
    for t in transforms { result = t(result) }
    return result
}
let input = "  Hello World 123  "
let out = pipeline(input, transforms: [
    trimWhitespace, lowercase, removeDigits, replaceSpaces(with: "-")
])
print(out)

func makePipeline(_ transforms: Transform...) -> Transform {
    return { input in
        var result = input
        for t in transforms { result = t(result) }
        return result
    }
}
let clean = makePipeline(trimWhitespace, lowercase)
print(clean(" HeLLo "))