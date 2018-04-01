import UIKit
import PlaygroundSupport

open class DelayOperation: Operation {
    private var _executing = false {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
        }
        didSet {
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    private var _finished = false {
        willSet {
            self.willChangeValue(forKey: "isFinished")
        }
        didSet {
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    private let delayInSeconds: TimeInterval
    
    public init(_ delayInSeconds: TimeInterval) {
        self.delayInSeconds = delayInSeconds
        super.init()
    }
    
    open override func cancel() {
        super.cancel()
        finish()
    }
    
    open override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        _executing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds, execute: { [weak self] in
            
            // If we were cancelled, then finish() has already been called.
            if self?.isCancelled == false {
                self?.finish()
            }
        })
    }
    
    func finish() {
        _executing = false
        _finished = true
    }
    
    override open var isExecuting: Bool {
        return _executing
    }
    
    override open var isFinished: Bool {
        return _finished
    }
}

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

public struct Row: MutableCollection, RandomAccessCollection {
    public typealias Blocks = [Block]
    
    public var blocks: Blocks
    
    public init(fromColor startColor: UIColor, toColor endColor: UIColor, quantity: Int) {
        self.blocks = .blocks(fromColor: startColor, toColor: endColor, quantity: quantity)
    }
    
    public init(quantity: Int) {
        self.blocks = .blocks(quantity: quantity)
    }
    
    public init() {
        self.init(squares: [])
    }
    
    public init(squares: Blocks) {
        self.blocks = squares
    }
    
    mutating func shuffle() {
        self.blocks.shuffle()
    }
    
    func shuffled() -> Row {
        return Row(squares: self.blocks.shuffled())
    }
    
    mutating func replace(_ newValues: [Block], startingIndex: Index) {
        let newSubrange = startingIndex..<(startingIndex + newValues.count)
        self.blocks.replaceSubrange(newSubrange, with: newValues)
    }
    
    // MARK: Collection
    
    public typealias Index = Blocks.Index
    public typealias Element = Blocks.Element
    
    public var startIndex: Index { return self.blocks.startIndex }
    public var endIndex: Index { return self.blocks.endIndex }
    
    /// Method that returns the next index when iterating
    public func index(after i: Index) -> Index {
        return self.blocks.index(after: i)
    }
    
    /// Required subscript, based on the block array
    public subscript(position: Index) -> Block {
        get {
            return self.blocks[position]
        }
        set(newValue) {
            self.blocks[position] = newValue
        }
    }

}

extension UIColor {
    
    var redComponent: CGFloat {
        return self.getRGBAComponents()?.red ?? 0
    }
    
    var greenComponent: CGFloat {
        return self.getRGBAComponents()?.green ?? 0
    }
    
    var blueComponent: CGFloat {
        return self.getRGBAComponents()?.blue ?? 0
    }
    
    var alpha: CGFloat {
        return self.getRGBAComponents()?.alpha ?? 0
    }
    
    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue, alpha)
        } else {
            return nil
        }
    }
    
    func getHSBAComponents() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)? {
        var (hue, saturation, brightness, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return (hue, saturation, brightness, alpha)
        } else {
            return nil
        }
    }
    
    func getGrayscaleComponents() -> (white: CGFloat, alpha: CGFloat)? {
        var (white, alpha) = (CGFloat(0.0), CGFloat(0.0))
        if self.getWhite(&white, alpha: &alpha) {
            return (white, alpha)
        } else {
            return nil
        }
    }
    
    static func color(from startColor: UIColor, to endColor: UIColor, at percentage: CGFloat) -> UIColor {
        let resultantRed = startColor.redComponent + percentage * (endColor.redComponent - startColor.redComponent)
        let resultantGreen = startColor.greenComponent + percentage * (endColor.greenComponent - startColor.greenComponent)
        let resultantBlue = startColor.blueComponent + percentage * (endColor.blueComponent - startColor.blueComponent)
        let resultantAlpha = startColor.alpha + percentage * (endColor.alpha - startColor.alpha)
        
        return UIColor(red: resultantRed, green: resultantGreen, blue: resultantBlue, alpha: resultantAlpha)
    }
    
    static func colors(from startColor: UIColor, to endColor: UIColor, quantity: Int) -> [UIColor] {
        guard quantity >= 2 else { return [] }
        
        var returnValue = [UIColor]()
        let step = (CGFloat(quantity) / (CGFloat(quantity) - 1))
        for index in 0..<quantity {
            returnValue.append(.color(from: startColor, to: endColor, at: (CGFloat(index) * step) / CGFloat(quantity)))
        }
        
        return returnValue
    }
    
    static func colors(quantity: Int) -> [UIColor] {
        var returnValue = [UIColor]()
        let step = (CGFloat(quantity) / (CGFloat(quantity) - 1))
        for index in 0..<quantity {
            returnValue.append(UIColor(hue: (CGFloat(index) * step) / CGFloat(quantity), saturation: 0.6, brightness: 1.0, alpha: 1.0))
        }
        
        return returnValue
    }
    
}

public struct Block: Equatable, Comparable, Hashable {
    public var color: UIColor
    var correctPosition: Int
    
    // MARK: Equatable comformance
    
    public static func ==(lhs: Block, rhs: Block) -> Bool {
        return lhs.color == rhs.color
            && lhs.correctPosition == rhs.correctPosition
    }
    
    // MARK: Comparable
    
    public static func <(lhs: Block, rhs: Block) -> Bool {
        return lhs.correctPosition < rhs.correctPosition
    }
    
    public static func <=(lhs: Block, rhs: Block) -> Bool {
        return lhs < rhs || lhs == rhs
    }
    
    public static func >(lhs: Block, rhs: Block) -> Bool {
        return lhs.correctPosition > rhs.correctPosition
    }
    
    public static func >=(lhs: Block, rhs: Block) -> Bool {
        return lhs > rhs || lhs == rhs
    }
    
}

extension Collection where Element == Block {
    static func blocks(fromColor startColor: UIColor, toColor endColor: UIColor, quantity: Int) -> [Block] {
        return UIColor.colors(from: startColor, to: endColor, quantity: quantity).enumerated().map({ Block(color: $0.element, correctPosition: $0.offset) })
    }
    
    static func blocks(quantity: Int) -> [Block] {
        return UIColor.colors(quantity: quantity).enumerated().map({ Block(color: $0.element, correctPosition: $0.offset) })
    }
}

// MARK: -

class BlockView: UIView {
    
    let block: Block
    
    init(square: Block) {
        self.block = square
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        self.backgroundColor = square.color
//        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        self.layer.borderColor = UIColor.white.cgColor
        //        self.layer.borderWidth = 0.5
    }
    
}

public class Pillars {
    
    public var pillarsCount: Int = 50
    public var pillarWidth: CGFloat = 10
    public var pillarHeightFactor: CGFloat = 10

    public var delayBetweenUpdates: TimeInterval = 0.005
    public var sorter: Sorter = QuickSorter()
    
    lazy var view: PillarsView = {
        let view = PillarsView()
        view.frame.size = CGSize(width: self.pillarWidth * CGFloat(self.row.count), height: self.pillarHeightFactor * CGFloat(self.row.count))
        return view
    }()
    
    lazy var row: Row = Row()//Row(quantity: self.pillarsCount).sorted()
    
    private let updateOperations: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }()
    
    public init() {
        
    }
    
    func updateRow(_ row: Row) {
        self.row = row
        self.view.updateLayout(withRow: self.row, pillarWidth: self.pillarWidth, pillarHeightFactor: self.pillarHeightFactor)
    }
    
    private func show() {
        self.updateRow(Row(quantity: self.pillarsCount).shuffled())
//        self.row = Row(quantity: self.pillarsCount).shuffled()

        PlaygroundPage.current.liveView = self.view
    }
    
    public func sort() {
        self.show()
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
            self.sorter.sortRow(self.row, updateRowTo: { (newRow) in
                let updateOperation = BlockOperation {
                    DispatchQueue.main.async {
                        self.updateRow(newRow)
                    }
                }
                self.updateOperations.addOperation(DelayOperation(self.delayBetweenUpdates))
                self.updateOperations.addOperation(updateOperation)
            })
        }
        
    }
    
    
}

class PillarsView: UIView {
    
//    var row: Row {
//        didSet {
//            self.updateLayout(withRow: self.row)
//            let frame = CGRect(x: 0, y: 0, width: self.pillarWidth * CGFloat(self.row.count), height: self.pillarHeightFactor * CGFloat(self.row.count))
//            self.frame = frame
//        }
//    }
    
    private var blockViews: [BlockView] {
        return self.subviews.compactMap({ $0 as? BlockView })
    }
    
    // MARK: - Constructors
    
//    init(withRow row: Row) {
//        self.row = row
//        super.init(frame: CGRect(x: 0, y: 0, width: self.pillarWidth * CGFloat(self.row.count), height: self.pillarHeightFactor * CGFloat(self.row.count)))
//    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .darkGray
//        self.row = Row()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        self.row = Row()
        super.init(coder: aDecoder)
        self.backgroundColor = .darkGray
    }
    
    // MARK: - UIView Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        for (index, blockView) in self.blockViews.enumerated() {
//            blockView.frame.origin.y = self.bounds.maxY - blockView.frame.size.height
//            blockView.frame.origin.x = CGFloat(index) * blockView.frame.size.width
//        }
    }
    
    // MARK: - Methods
    
    func updateLayout(withRow row: Row, pillarWidth: CGFloat, pillarHeightFactor: CGFloat) {
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        for (index, block) in row.blocks.enumerated() {
            let blockView = BlockView(square: block)
            blockView.frame.size.height = CGFloat(block.correctPosition + 1) * pillarHeightFactor
            blockView.frame.size.width = pillarWidth
            blockView.frame.origin.y = self.bounds.maxY - blockView.frame.size.height
            blockView.frame.origin.x = CGFloat(index) * blockView.frame.size.width
            self.addSubview(blockView)
        }
        
//        self.setNeedsLayout()
        CATransaction.flush()
    }
    
}

let pillars = Pillars()
pillars.sort()
