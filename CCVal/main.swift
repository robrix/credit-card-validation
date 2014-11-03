import Darwin

// MARK: “Generic”

extension Int {
	init(string: String) {
		self = String(string).withCString(atol)
	}
}

func rightCurry<T, U, V, W>(f: (T, U, V) -> W)(z: V)(y: U)(x: T) -> W {
	return f(x, y, z)
}

func rightCurry<T, U, V>(f: (T, U) -> V)(y: U)(x: T) -> V {
	return f(x, y)
}

func freeFunctionWithMethod<T, U>(f: T -> () -> U) -> T -> U {
	return { f($0)() }
}

infix operator • {
	associativity left
}
func • <T, U, V> (g: U -> V, f: T -> U) -> T -> V {
	return { x in g(f(x)) }
}


func iff<T>(condition: Bool, then: @autoclosure () -> T, otherwise: @autoclosure () -> T) -> T {
	return condition.boolValue ? then() : otherwise()
}


// MARK: Specific

let reverse: [Int] -> [Int] = freeFunctionWithMethod(Array.reverse)

func doubleEveryOther(digits: [Int]) -> [Int] {
	return map(enumerate(digits)) {
		($0.0 % 2 == 1) ? $0.1 * 2 : $0.1
	}
}

func splitDigits(digits: [Int]) -> [Int] {
	return join([], map(digits) {
		(Double($0) / 10.0 < 1.0) ? [$0] : [1, $0 % 10]
	})
}

let is0 = rightCurry(==)(y: 0)
let mod10 = rightCurry(%)(y: 10)
let isDivisibleBy10 = is0 • mod10

func digitsWithString(string: String) -> [Int] {
	return map(Array(string)) { Int(string: String($0)) }
}

let smilify = rightCurry(iff as (Bool, () -> String, () -> String) -> String)(z: {"😡"})(y: {"😁"})

func reduceArray<T, U>(array: [T], initial: U, combine: (U, T) -> U) -> U {
	return reduce(array, initial, combine)
}

let sum = rightCurry(reduceArray)(z: +)(y: 0)


// MARK: Extremely specific

let validCCToSmiley = smilify • isDivisibleBy10 • sum • splitDigits • doubleEveryOther • reverse • digitsWithString

println(Process.arguments.last.map { validCCToSmiley($0) })
