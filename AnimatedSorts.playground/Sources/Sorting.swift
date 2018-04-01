//
//  Sorting.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 26/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import Foundation

public protocol Sorter {
    
    func sortRow(_ row: Row, updateRowTo: (Row) -> Void)
    
}

// MARK: -

public class BubbleSorter: Sorter {
    
    public init() {}

    // MARK: Sorter Conformance

    public func sortRow(_ row: Row, updateRowTo: (Row) -> Void) {
        var squares = row
        var isSorted: Bool
        repeat {
            isSorted = true
            
            // Check each value in the array
            for i in 0..<(squares.endIndex - 1) where squares[i] > squares[i + 1] {
                squares.swapAt(i, i + 1)
                updateRowTo(squares)
                isSorted = false
            }
        } while (isSorted == false)

    }
    
}

// MARK: -

public class QuickSorter: Sorter {
    
    public init() {}
    
    /// Quick sort a subarray from index start...end
    /// Note that you can randomly pick a pivotIndex and avoid worst case O(N^2) complexity when the starting array is reversed.
    private func quickSort(range: CountableClosedRange<Int>, ofRow row: inout Row, updateRowTo: (Row) -> Void) {
        guard range.lowerBound < range.upperBound else { return }
        
        let pivot = row[(range.lowerBound + range.upperBound) / 2]
        
        let newPivotIndex = self.sortPivot(pivot, inRow: &row, range: range, updateRowTo: updateRowTo)
        self.quickSort(range: range.lowerBound...newPivotIndex, ofRow: &row, updateRowTo: updateRowTo)
        self.quickSort(range: (newPivotIndex + 1)...range.upperBound, ofRow: &row, updateRowTo: updateRowTo)
    }
    
    /// The array is partitioned into [start...p] and [p+1...end]
    /// All elements in the left array <= the pivot.
    /// All elements in the right array > the pivot.
    /// Return p, the end index of the left array.
    /// Note this may not be the pivot's index.
    private func sortPivot(_ pivot: Block, inRow row: inout Row, range: CountableClosedRange<Int>, updateRowTo: (Row) -> Void) -> Int {
        var i = range.lowerBound - 1
        var j = range.upperBound + 1
        
        while true {
            repeat { i += 1 } while row[i] < pivot
            repeat { j -= 1 } while row[j] > pivot
            
            if i < j {
                row.swapAt(i, j)
                updateRowTo(row)
            } else {
                return j
            }
        }
    }
    
    // MARK: Sorter Conformance
    
    public func sortRow(_ row: Row, updateRowTo: (Row) -> Void) {
        var row = row
        self.quickSort(range: CountableClosedRange(row.startIndex..<row.endIndex), ofRow: &row, updateRowTo: updateRowTo)
    }

}

// MARK: -

public class MergeSorter: Sorter {
    
    public init() {}

    private func merge(from start: Int, _ left: [Block], _ right: [Block], row: inout Row, updateRowTo: (Row) -> Void) -> [Block] {
        var leftIndex = 0
        var rightIndex = 0
        
        var orderedArray: [Block] = []
        
        while leftIndex < left.count && rightIndex < right.count {
            let leftElement = left[leftIndex]
            let rightElement = right[rightIndex]
            
            if leftElement < rightElement {
                orderedArray.append(leftElement)
                leftIndex += 1
            } else if leftElement > rightElement {
                orderedArray.append(rightElement)
                rightIndex += 1
            } else {
                orderedArray.append(leftElement)
                leftIndex += 1
                orderedArray.append(rightElement)
                rightIndex += 1
            }
            
            // Update Method A - Update after each element was appended
            let remainingLeft = Array(left[leftIndex ..< left.count])
            let remainingRight = Array(right[rightIndex ..< right.count])
            let newValues = orderedArray + remainingLeft + remainingRight
            
            
            row.blocks.replace(newValues, startingIndex: start)
            updateRowTo(row)
        }
        
        while leftIndex < left.count {
            orderedArray.append(left[leftIndex])
            leftIndex += 1
        }
        
        while rightIndex < right.count {
            orderedArray.append(right[rightIndex])
            rightIndex += 1
        }
        
        return orderedArray
    }
    
    // Note the 'start' param is used for display, not the algorithm.
    private func mergeSort(from start: Int, row: inout [Block], updateRowTo: (Row) -> Void, fullRow: inout Row) {
        guard row.count > 1 else { return }
        
        let midIndex = row.count / 2
        var left = Array(row[0 ..< midIndex])
        var right = Array(row[midIndex ..< row.count])
        
        mergeSort(from: start, row: &left, updateRowTo: updateRowTo, fullRow: &fullRow)
        mergeSort(from: start + midIndex, row: &right, updateRowTo: updateRowTo, fullRow: &fullRow)
        
        row = merge(from: start, left, right, row: &fullRow, updateRowTo: updateRowTo)
        
        // Update Method B - Only update after merging two arrays
        // arrayView.replaceValues(newValues: a, startingFrom: start)
    }

    // MARK: Sorter Conformance
    
    public func sortRow(_ row: Row, updateRowTo: (Row) -> Void) {
        var row = row
        var initialBlocks = row.blocks
        self.mergeSort(from: 0, row: &initialBlocks, updateRowTo: updateRowTo, fullRow: &row)
    }
    
}

// MARK: -

public class InsertionSorter: Sorter {
    
    public init() {}
    
    private func insertionSort(_ array: inout Row, updateRowTo: (Row) -> Void) {
        guard array.count > 1 else { return }
        
        for outerIndex in 1..<array.count {
            var innerIndex = outerIndex
            let currentElement = array[innerIndex]
            while innerIndex > 0 && currentElement < array[innerIndex - 1] {
                array[innerIndex] = array[innerIndex - 1]
                innerIndex -= 1
                updateRowTo(array)
                
            }
            array[innerIndex] = currentElement
        }
        
    }
    
    // MARK: Sorter Conformance
    
    public func sortRow(_ row: Row, updateRowTo: (Row) -> Void) {
        var row = row
        self.insertionSort(&row, updateRowTo: updateRowTo)
    }

}
