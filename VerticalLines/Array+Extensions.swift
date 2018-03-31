import Foundation

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
