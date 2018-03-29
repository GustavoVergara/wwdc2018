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

extension Array {
    
    public mutating func shuffle() {
        guard self.count > 1 else { return }
        for index in self.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(self.endIndex - index))) + index
            if index != randomIndex {
                self.swapAt(index, randomIndex)
            }
        }
    }
    
    public func shuffled() -> [Element] {
        var array = self
        array.shuffle()
        return array
    }
    
}
