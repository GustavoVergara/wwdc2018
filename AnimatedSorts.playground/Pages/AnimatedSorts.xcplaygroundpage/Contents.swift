import UIKit
import PlaygroundSupport


let grid = Grid()

//: You can change this properties to change how the grid is setup
grid.amountOfRows = 20
grid.amountOfBlocksPerRow = 70
grid.delayBetweenUpdates = 0.015
//:  You can pick other alredy implemented sorts, like:
/*:
    - QuickSorter
    - MergeSorter
    - BubbleSorter
    - InsertionSorter
 */
grid.sorter = QuickSorter()

grid.sort()
