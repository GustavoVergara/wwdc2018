//
//  ViewController.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 24/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import UIKit

// MARK: -

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

class SquareView: UIView {
    
    let square: Block
    
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: 10, height: 10)
//    }
    
    init(square: Block) {
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
        
//        self.layer.borderColor = UIColor.white.cgColor
//        self.layer.borderWidth = 0.5
    }
    
}
