//
//  ViewController.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 24/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import UIKit

public struct Square: Equatable, Comparable {
    public var color: UIColor
    var correctPosition: Int
    
    public static func ==(lhs: Square, rhs: Square) -> Bool {
        return lhs.color == rhs.color
            && lhs.correctPosition == rhs.correctPosition
    }

    // MARK: Equatable comformance
    
    static func squares(fromColor startColor: UIColor, toColor endColor: UIColor, quantity: Int) -> [Square] {
        return UIColor.colors(from: startColor, to: endColor, quantity: quantity).enumerated().map({ Square(color: $0.element, correctPosition: $0.offset) })
    }
    
    // MARK: Comparable
    
    public static func <(lhs: Square, rhs: Square) -> Bool {
        return lhs.correctPosition < rhs.correctPosition
    }
    
    public static func <=(lhs: Square, rhs: Square) -> Bool {
        return lhs < rhs || lhs == rhs
    }
    
    public static func >(lhs: Square, rhs: Square) -> Bool {
        return lhs.correctPosition > rhs.correctPosition
    }
    
    public static func >=(lhs: Square, rhs: Square) -> Bool {
        return lhs > rhs || lhs == rhs
    }

}

class SquareView: UIView {
    
    let square: Square
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    init(square: Square) {
        self.square = square
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        self.backgroundColor = square.color
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5
    }
    
}

public struct Line {
    public var squares: [Square]
    
    public init(fromColor startColor: UIColor, toColor endColor: UIColor, quantity: Int) {
        self.squares = Square.squares(fromColor: startColor, toColor: endColor, quantity: quantity)
    }
    
    public init(squares: [Square]) {
        self.squares = squares
    }
    
    mutating func shuffle() {
        self.squares.shuffle()
    }
    
}

class LineView: UIStackView {
    
    var squareViews: [SquareView] {
        return self.arrangedSubviews.flatMap({ $0 as? SquareView })
    }
    
    var squares: [Square] {
        return self.line.squares
    }
    
    private(set) var line: Line
    
    convenience init(withSquares squares: [Square]) {
        self.init(withLine: Line(squares: squares))
    }
    
    init(withLine line: Line) {
        self.line = line
        super.init(frame: .zero)
        
        self.distribution = .fillEqually

        for square in line.squares {
            let squareView = SquareView(square: square)
            self.addArrangedSubview(squareView)
        }
    }
    
    required init(coder: NSCoder) {
        self.line = Line(squares: [])
        super.init(coder: coder)
        self.distribution = .fillEqually
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        
    }
    
}

public struct Grid {
    public var startColor: UIColor = .purple
    public var endColor: UIColor = .green
    public var amountOfHorizontalLines: Int = 50
    public var amountOfVerticalSquares: Int = 50
    
    lazy var lines: [Line] = {
        var lines = [Line]()
        for _ in (0..<self.amountOfHorizontalLines) {
            var line = Line(fromColor: self.startColor, toColor: self.endColor, quantity: self.amountOfVerticalSquares)
            line.shuffle()
            lines.append(line)
        }
        return lines
    }()
    
    public init(startColor: UIColor, endColor: UIColor, amountOfHorizontalLines: Int, amountOfVerticalSquares: Int) {
        self.startColor = startColor
        self.endColor = endColor
        self.amountOfHorizontalLines = amountOfHorizontalLines
        self.amountOfVerticalSquares = amountOfVerticalSquares
    }
    
    public init() {}
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

