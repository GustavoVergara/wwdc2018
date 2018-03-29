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

class QuickSort: Sorter { // TODO: Make it work :)
    
    @discardableResult
    private func sortedBlocks(_ blocks: [Block], updateRowWith: @escaping ([Block]) -> Void) -> [Block] {
        guard blocks.count > 1 else {
            
            return blocks
        }
        let pivot = blocks[blocks.endIndex / 2]
        
        var lessThan = [Block]()
        var greaterThan = [Block]()
        var equalAs = [pivot]
        
        for block in blocks {
            if block < pivot {
                lessThan.append(block)
            } else if block > pivot {
                greaterThan.append(block)
            } else {
                equalAs.append(block)
            }
        }
        
        let returnValue = sortedBlocks(lessThan, updateRowWith: updateRowWith) + equalAs + sortedBlocks(greaterThan, updateRowWith: updateRowWith)
        updateRowWith(returnValue)
        return returnValue
    }
    
    func sortSquares(_ squares: [Block], updateRowWith: @escaping ([Block]) -> Void) {
        self.sortedBlocks(squares, updateRowWith: updateRowWith)
    }

}
