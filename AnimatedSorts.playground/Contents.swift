import UIKit
import PlaygroundSupport


let grid = Grid()

//: You can change this properties to change how the grid is setup
grid.amountOfRows = 2
grid.amountOfBlocksPerRow = 150
grid.delayBetweenUpdates = 0.015
//:  You can pick other alredy implemented sorts, like:
/*:
    - QuickSorter
    - MergeSorter
    - BubbleSorter
    - InsertionSorter
 */
//: Or you can implement other sorts yourself 😀
grid.sorter = InsertionSorter()

grid.sort()
