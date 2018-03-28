import Foundation

public func randomArray(length: Int, max: Int) -> [Int] {
    var array = [Int]()
    
    let min = max / 30
    for _ in 1...length {
        let randomDiff = Int(arc4random_uniform(UInt32(max - min)))
        array.append(min + randomDiff)
    }
    
    return array
}

public extension Array {
    public mutating func replace(_ newValues: [Element], startingIndex: Index) {
        let newSubRange = startingIndex..<(startingIndex + newValues.count)
        self.replaceSubrange(newSubRange, with: newValues)
    }
}
