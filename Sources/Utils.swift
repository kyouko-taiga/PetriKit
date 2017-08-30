public func hash(_ sequence: [Int]) -> Int {
    var result = 17
    for element in sequence {
        result ^= element + 0x9e3779b9
    }
    return result
}

public func hash(_ sequence: Int...) -> Int {
    return hash(sequence)
}

public func hash<T: Sequence>(_ sequence: T) -> Int where T.Iterator.Element: Hashable {
    return hash(sequence.map{ $0.hashValue })
}
