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

class BubbleSorter: Sorter {
    
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

class QuickSorter: Sorter {
    
    /// Quick sort a subarray from index start...end
    /// Note that you can randomly pick a pivotIndex and avoid worst case O(N^2) complexity when the starting array is reversed.
    func quickSort(range: CountableClosedRange<Int>, ofLine line: inout [Block], updateRowWith: ([Block]) -> Void) {
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
    func sortPivot(_ pivot: Block, inLine line: inout [Block], range: CountableClosedRange<Int>, updateRowWith: ([Block]) -> Void) -> Int {
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
    
//    @discardableResult
//    private func sortedBlocks(_ blocks: [Block], updateRowWith: @escaping ([Block]) -> Void) -> [Block] {
//        var blocks = blocks
//        self.quickSort(&blocks, start: blocks.startIndex, end: blocks.endIndex - 1)
//        guard blocks.count > 1 else {
//
//            return blocks
//        }
//        let pivot = blocks[blocks.endIndex / 2]
//
//        var lessThan = [Block]()
//        var greaterThan = [Block]()
//        var equalAs = [pivot]
//
//        for block in blocks {
//            if block < pivot {
//                lessThan.append(block)
//            } else if block > pivot {
//                greaterThan.append(block)
//            } else {
//                equalAs.append(block)
//            }
//        }
//
//        let returnValue = sortedBlocks(lessThan, updateRowWith: updateRowWith) + equalAs + sortedBlocks(greaterThan, updateRowWith: updateRowWith)
//        updateRowWith(returnValue)
//        return returnValue
//    }
    
    func sortSquares(_ squares: [Block], updateRowWith: @escaping ([Block]) -> Void) {
        var blocks = squares
        self.quickSort(range: CountableClosedRange(blocks.startIndex..<blocks.endIndex), ofLine: &blocks, updateRowWith: updateRowWith)

//        self.sortedBlocks(squares, updateRowWith: updateRowWith)
    }

}
