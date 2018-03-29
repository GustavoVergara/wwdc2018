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
    
    init(fromColor startColor: UIColor, toColor endColor: UIColor, quantity: Int) {
        self.blocks = .blocks(fromColor: startColor, toColor: endColor, quantity: quantity)
    }
    
    public init(squares: Blocks) {
        self.blocks = squares
    }
    
    mutating func shuffle() {
        self.blocks.shuffle()
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
    
    /// Required subscript, based on the square array
    public subscript(position: Index) -> Iterator.Element {
        get {
            return self.blocks[position]
        }
        set(newValue) {
            self.blocks[position] = newValue
        }
    }
    
}

// MARK: -

class LineView: UIStackView {
    
    var squareViews: [SquareView] {
        return self.arrangedSubviews.flatMap({ $0 as? SquareView })
    }
    
    var squares: [Block] {
        return self.line.blocks
    }
    
    var line: Row {
        didSet {
            self.recreateBlocks()
        }
    }
    
    convenience init(withSquares squares: [Block]) {
        self.init(withRow: Row(squares: squares))
    }
    
    init(withRow line: Row) {
        self.line = line
        super.init(frame: .zero)
        self.distribution = .fillEqually
        
        self.recreateBlocks()
    }
    
    required init(coder: NSCoder) {
        self.line = Row(squares: [])
        super.init(coder: coder)
        self.distribution = .fillEqually
    }
    
    private func recreateBlocks() {
        self.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        for block in self.line.blocks {
            let squareView = SquareView(square: block)
            self.addArrangedSubview(squareView)
        }
    }
    
}
