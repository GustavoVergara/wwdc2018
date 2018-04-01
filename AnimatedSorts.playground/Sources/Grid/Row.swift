//
//  Line.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 27/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import Foundation
import UIKit

// MARK: -

public struct Row {
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
    
    mutating func replace(_ newValues: [Block], startingIndex: Index) {
        let newSubrange = startingIndex..<(startingIndex + newValues.count)
        self.blocks.replaceSubrange(newSubrange, with: newValues)
    }
}

extension Row: MutableCollection, RandomAccessCollection {
    
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

// MARK: -

class HorizontalRowView: UIView {
    
    var squareViews: [BlockView] {
        return self.subviews.compactMap({ $0 as? BlockView })
    }
    
    var blocks: [Block] {
        return self.row.blocks
    }
    
    var row: Row {
        didSet {
//            if Set(self.row) == Set(oldValue) {
//                self.setNeedsLayout()
//            } else {
            self.recreateBlocks()
//            }
        }
    }
    
    convenience init(withSquares squares: [Block]) {
        self.init(withRow: Row(squares: squares))
    }
    
    init(withRow line: Row) {
        self.row = line
        super.init(frame: .zero)
//        self.distribution = .fillEqually
        
        self.recreateBlocks()
    }
    
    required init?(coder: NSCoder) {
        self.row = Row(squares: [])
        super.init(coder: coder)
//        self.distribution = .fillEqually
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let blockWidth = self.bounds.width / CGFloat(self.squareViews.count)
        for (index, blockView) in self.squareViews.enumerated() {
            blockView.frame.origin.x = CGFloat(index) * blockWidth
            blockView.frame.size.width = blockWidth
            blockView.frame.size.height = self.bounds.height
        }
    }
    
    private func recreateBlocks() {
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        for block in self.row {
            let squareView = BlockView(square: block)
            self.addSubview(squareView)
        }
        
        self.setNeedsLayout()
    }
    
    
}
