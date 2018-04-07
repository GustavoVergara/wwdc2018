
let grid = Grid()

grid.amountOfRows = 20
grid.amountOfBlocksPerRow = 50
grid.delayBetweenUpdates = 0.015

class MySorter: Sorter {
    
    func sortRow(_ row: Row, updateRowTo: (Row) -> Void) {
        // Use the `updateRowTo` each time you update the row
        guard row.count > 1 else { return }
        var row = row
        
        for outerIndex in 1..<row.count {
            var innerIndex = outerIndex
            let currentElement = row[innerIndex]
            while innerIndex > 0 && currentElement < row[innerIndex - 1] {
                row[innerIndex] = row[innerIndex - 1]
                innerIndex -= 1
                updateRowTo(row)
                
            }
            row[innerIndex] = currentElement
        }
    }
    
}

grid.sorter = MySorter()

grid.sort()

