//
//  GridViewController.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 25/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import Foundation
import UIKit

class GridViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: Public
    public var squarePerLine: Int = 50
    public var lines: Int = 50
    
    public var startColor: UIColor = .purple
    public var endColor: UIColor = .green
//    {
//        didSet {
//            self.squares = (0..<self.squarePerLine).map({ Square(color: .purple, correctPosition: $0) })
//        }
//    }
    
    // MARK: Private
    
    private var lineViews: [LineView] {
        //.verticalStackView.arrangedSubviews
        return self.view.subviews.flatMap({ $0 as? LineView })
    }
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return stackView
    }()
//
//    var squares: [Square] = [Square(color: .purple, correctPosition: 0), Square(color: .green, correctPosition: 1), Square(color: .blue, correctPosition: 2)] {
//        didSet {
//            guard self.squares != oldValue else { return }
//
//            self.view?.subviews.forEach({ $0.removeFromSuperview() })
//
//            for lineStackView in self.createLines() {
//                self.verticalStackView.addArrangedSubview(lineStackView)
//            }
//
//        }
//    }
//
//    private var horizontalStackViews: [UIStackView] {
//        return self.view?.subviews.flatMap({ $0 as? UIStackView }) ?? []
//    }
    
    // MARK: - UIViewController Overrides
    
    public override func loadView() {
        let view = UIView()
        view.backgroundColor = .darkGray

//        self.verticalStackView.frame = view.bounds
//        view.addSubview(self.verticalStackView)

//        self.verticalStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        self.verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        self.verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        self.verticalStackView.setContentCompressionResistancePriority(.required, for: .vertical)

        for lineStackView in self.createLines() {
            view.addSubview(lineStackView)
//            self.verticalStackView.addArrangedSubview(lineStackView)
        }

        self.view = view
        
        self.layoutLines()
    }
    
    override func viewDidLayoutSubviews() {
        self.layoutLines()
        
        super.viewDidLayoutSubviews()
    }
    
    func layoutLines() {
        let lineHeight = self.view.bounds.height / CGFloat(self.lines)
        for (index, lineView) in self.lineViews.enumerated() {
            lineView.frame.origin.y = lineHeight * CGFloat(index)
            lineView.frame.size.height = lineHeight
            lineView.frame.size.width = self.view.bounds.width
        }
    }
    
    // MARK: - Creation
    
    //, fromColor startColor: UIColor, toColor endColor: UIColor
//    func createSquares(ofSize size: CGSize) -> [SquareView] {
//        let squares = Square.squares(fromColor: self.startColor, toColor: self.endColor, quantity: self.squarePerLine)
//        var squareViews = [SquareView]()
//        for square in squares {
//            let squareView = SquareView(square: square)
//            squareView.frame.size = size
//            squareViews.append(squareView)
//        }
//        return squareViews
//    }
    
    func createSquares() -> [Square] {
        return Square.squares(fromColor: self.startColor, toColor: self.endColor, quantity: self.squarePerLine)
    }
    
    func createLines() -> [LineView] {
        let squares = self.createSquares()
        var lines = [LineView]()
        for _ in 0..<self.lines {
            let line = LineView(withSquares: squares.shuffled())
            line.distribution = .fillEqually
            lines.append(line)
        }
        return lines
    }
    
//    func createLines() -> [UIStackView] {
//        return (0..<self.lines).map({ self.createLine(at: $0) })
//    }
//
//    func createLine(at index: Int) -> UIStackView {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.alignment = .trailing
//
//        for squareView in self.createSquares(forLineAt: index) {
//            stackView.addArrangedSubview(squareView)
//        }
//
//        return stackView
//    }
//
//    func createSquares(forLineAt index: Int) -> [SquareView] {
//        return self.squares.shuffled().map({ SquareView(square: $0) })
//    }
    
//    func createColors(from startColor: UIColor, to endColor: UIColor, quantity) -> [UIColor] {
//
//    }
        
}

class LineView: UIStackView {
    
    var squareViews: [SquareView] {
        return self.arrangedSubviews.flatMap({ $0 as? SquareView })
    }
    
    var squares: [Square] {
        return self.squareViews.map({ $0.square })
    }
    
    init(withSquares squares: [Square]) {
        super.init(frame: .zero)
        
        for square in squares {
            let squareView = SquareView(square: square)
            self.addArrangedSubview(squareView)
        }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
