//
//  Line.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 27/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import Foundation
import UIKit

public struct Line {
    public typealias Squares = [Square]
    
    public var squares: Squares
    
    init(fromColor startColor: UIColor, toColor endColor: UIColor, quantity: Int) {
        self.squares = Square.squares(fromColor: startColor, toColor: endColor, quantity: quantity)
    }
    
    public init(squares: Squares) {
        self.squares = squares
    }
    
    mutating func shuffle() {
        self.squares.shuffle()
    }
    
}

extension Line: MutableCollection, RandomAccessCollection {
    
    public typealias Index = Squares.Index
    public typealias Element = Squares.Element
    
    public var startIndex: Index { return self.squares.startIndex }
    public var endIndex: Index { return self.squares.endIndex }

    /// Method that returns the next index when iterating
    public func index(after i: Index) -> Index {
        return self.squares.index(after: i)
    }
    
    /// Required subscript, based on the square array
    public subscript(position: Index) -> Iterator.Element {
        get {
            return self.squares[position]
        }
        set(newValue) {
            self.squares[position] = newValue
        }
    }
    
}
