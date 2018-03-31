//
//  Sorting.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 26/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import Foundation

public protocol Sorter {
    
    func sortSquares(_ squares: [Block], updateRowWith: @escaping ([Block]) -> Void)
    
}

//extension Sorter {
//    static var bubbleSorter: Sorter { return BubbleSorter() }
//    static var quickSorter: Sorter { return QuickSorter() }
//    static var mergeSorter: Sorter { return MergeSorter() }
//}

// MARK: -

class BubbleSorter: Sorter {
    
    // MARK: Sorter Conformance

    func sortSquares(_ squares: [Block], updateRowWith: @escaping ([Block]) -> Void) {
        var squares = squares
        var isSorted: Bool
        repeat {
            isSorted = true
            
            // Check each value in the array
            for i in 0..<(squares.endIndex - 1) where squares[i] > squares[i + 1] {
                squares.swapAt(i, i + 1)
                updateRowWith(squares)
                isSorted = false
            }
        } while (isSorted == false)

    }
    
}

// MARK: -

class QuickSorter: Sorter {
    
    /// Quick sort a subarray from index start...end
    /// Note that you can randomly pick a pivotIndex and avoid worst case O(N^2) complexity when the starting array is reversed.
    private func quickSort(range: CountableClosedRange<Int>, ofLine line: inout [Block], updateRowWith: ([Block]) -> Void) {
        guard range.lowerBound < range.upperBound else { return }
        
        let pivot = line[(range.lowerBound + range.upperBound) / 2]
        
        let newPivotIndex = self.sortPivot(pivot, inLine: &line, range: range, updateRowWith: updateRowWith)
        self.quickSort(range: range.lowerBound...newPivotIndex, ofLine: &line, updateRowWith: updateRowWith)
        self.quickSort(range: (newPivotIndex + 1)...range.upperBound, ofLine: &line, updateRowWith: updateRowWith)
    }
    
    /// The array is partitioned into [start...p] and [p+1...end]
    /// All elements in the left array <= the pivot.
    /// All elements in the right array > the pivot.
    /// Return p, the end index of the left array.
    /// Note this may not be the pivot's index.
    private func sortPivot(_ pivot: Block, inLine line: inout [Block], range: CountableClosedRange<Int>, updateRowWith: ([Block]) -> Void) -> Int {
        var i = range.lowerBound - 1
        var j = range.upperBound + 1
        
        while true {
            repeat { i += 1 } while line[i] < pivot
            repeat { j -= 1 } while line[j] > pivot
            
            if i < j {
                line.swapAt(i, j)
                updateRowWith(line)
            } else {
                return j
            }
        }
    }
    
    // MARK: Sorter Conformance
    
    func sortSquares(_ squares: [Block], updateRowWith: @escaping ([Block]) -> Void) {
        var blocks = squares
        self.quickSort(range: CountableClosedRange(blocks.startIndex..<blocks.endIndex), ofLine: &blocks, updateRowWith: updateRowWith)
    }

}

// MARK: -

class MergeSorter: Sorter {
    
//    private func merge(from start: Int, line: inout [Block], leftRange: Range<Int>, rightRange: Range<Int>, updateRowWith: ([Block]) -> Void) {
//        var leftIndex = leftRange.lowerBound
////        let leftLine = Array(line[leftRange])
//        var rightIndex = rightRange.lowerBound
////        let rightLine = Array(line[rightRange])
//
//        var orderedArray: [Block] = []
//
//        while leftIndex <= leftRange.upperBound && rightIndex <= rightRange.upperBound {
//            let leftElement = line[leftIndex]
//            let rightElement = line[rightIndex]
//
//            if leftElement < rightElement {
//                orderedArray.append(leftElement)
//                leftIndex += 1
//            } else if leftElement > rightElement {
//                orderedArray.append(rightElement)
//                rightIndex += 1
//            } else {
//                orderedArray.append(leftElement)
//                leftIndex += 1
//                orderedArray.append(rightElement)
//                rightIndex += 1
//            }
//
//            // Update Method A - Update after each element was appended
//            let remainingLeft = Array(line[leftIndex...leftRange.upperBound])
//            let remainingRight = Array(line[rightIndex...rightRange.upperBound])
//            let newValues = orderedArray + remainingLeft + remainingRight
//
////            line[start..<(start + newValues.count)] = newValues
//            line.replace(newValues, startingIndex: start)
//            updateRowWith(line)
//        }
//
//        while leftIndex < leftLine.count {
//            orderedArray.append(leftLine[leftIndex])
//            leftIndex += 1
//        }
//
//        while rightIndex < rightLine.count {
//            orderedArray.append(rightLine[rightIndex])
//            rightIndex += 1
//        }
//
////        return orderedArray
//    }
//
//    // Note the 'start' param is used for display, not the algorithm.
//    private func mergeSort(from start: Int, line: inout [Block], updateRowWith: @escaping ([Block]) -> Void) {
//        guard line.count > 1 else { return }
//
//        let midIndex = line.count / 2
//        var left = Array(line[0 ..< midIndex])
//        var right = Array(line[midIndex ..< line.count])
//
//        mergeSort(from: start, line: &left, updateRowWith: updateRowWith)
//        mergeSort(from: start + midIndex, line: &right, updateRowWith: updateRowWith)
//
//        self.merge(from: start, line: &line, leftRange: 0..<midIndex, rightRange: midIndex..<line.count, updateRowWith: updateRowWith)
//    }

    public func merge(from start: Int, _ left: [Block], _ right: [Block], row: inout [Block], updateRowWith: ([Block]) -> Void) -> [Block] {
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
            
            row.replace(newValues, startingIndex: start)
            updateRowWith(row)
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
    func mergeSort(from start: Int, row: inout [Block], updateRowWith: ([Block]) -> Void, fullRow: inout [Block]) {
        guard row.count > 1 else { return }
        
        let midIndex = row.count / 2
        var left = Array(row[0 ..< midIndex])
        var right = Array(row[midIndex ..< row.count])
        
        mergeSort(from: start, row: &left, updateRowWith: updateRowWith, fullRow: &fullRow)
        mergeSort(from: start + midIndex, row: &right, updateRowWith: updateRowWith, fullRow: &fullRow)
        
        row = merge(from: start, left, right, row: &fullRow, updateRowWith: updateRowWith)
        
        // Update Method B - Only update after merging two arrays
        // arrayView.replaceValues(newValues: a, startingFrom: start)
    }

    // MARK: Sorter Conformance
    
    func sortSquares(_ squares: [Block], updateRowWith: @escaping ([Block]) -> Void) {
        var blocks = squares
        var initialRow = blocks
        self.mergeSort(from: 0, row: &initialRow, updateRowWith: updateRowWith, fullRow: &blocks)
    }
    
}
