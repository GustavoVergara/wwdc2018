//
//  ViewController.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 24/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: Public
    public var squarePerLine: Int = 5 {
        didSet {
            self.squares = (0..<self.squarePerLine).map({ Square(color: .purple, correctPosition: $0) })
        }
    }
    public var lines: Int = 5
    
    // MARK: Private
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
//        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return stackView
    }()
    
    var squares: [Square] = [Square(color: .purple, correctPosition: 0), Square(color: .green, correctPosition: 1), Square(color: .blue, correctPosition: 2)] {
        didSet {
            guard self.squares != oldValue else { return }
            
            self.view?.subviews.forEach({ $0.removeFromSuperview() })
            
            for lineStackView in self.createLines() {
                self.verticalStackView.addArrangedSubview(lineStackView)
            }

        }
    }
    
    private var horizontalStackViews: [UIStackView] {
        return self.view?.subviews.flatMap({ $0 as? UIStackView }) ?? []
    }
    
    // MARK: - UIViewController Overrides
    
    public override func loadView() {
        let view = UIView()
        view.backgroundColor = .darkGray
        
        self.verticalStackView.frame = view.bounds
        view.addSubview(self.verticalStackView)
        
        self.verticalStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.verticalStackView.setContentCompressionResistancePriority(.required, for: .vertical)

        for lineStackView in self.createLines() {
            self.verticalStackView.addArrangedSubview(lineStackView)
        }
        
        view.setNeedsUpdateConstraints()
        view.setNeedsLayout()
        
        self.view = view
    }
    
    // MARK: -
    
    
    
    func createLines() -> [UIStackView] {
        return (0..<self.lines).map({ self.createLine(at: $0) })
    }
    
    func createLine(at index: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        
        for squareView in self.createSquares(forLineAt: index) {
            stackView.addArrangedSubview(squareView)
        }
        
        return stackView
    }
    
    func createSquares(forLineAt index: Int) -> [SquareView] {
        return self.squares.shuffled().map({ SquareView(square: $0) })
    }
    
}

struct Square: Equatable {
    var color: UIColor
    var correctPosition: Int
    
    static func ==(lhs: Square, rhs: Square) -> Bool {
        return lhs.color == rhs.color
            && lhs.correctPosition == rhs.correctPosition
    }

    static func squares(fromColor startColor: UIColor, toColor endColor: UIColor, quantity: Int) -> [Square] {
        return UIColor.colors(from: startColor, to: endColor, quantity: quantity).enumerated().map({ Square(color: $0.element, correctPosition: $0.offset) })
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

extension Array {
    public mutating func shuffle() {
        guard self.count > 1 else { return }
        for index in self.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(endIndex - index))) + index
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

