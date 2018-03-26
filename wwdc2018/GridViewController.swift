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
    public var squarePerLine: Int = 5
    
    public var startColor: UIColor = .purple
    public var endColor: UIColor = .green
//    {
//        didSet {
//            self.squares = (0..<self.squarePerLine).map({ Square(color: .purple, correctPosition: $0) })
//        }
//    }
    
    // MARK: Private
    
//    private let verticalStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.alignment = .top
//        stackView.axis = .vertical
//        stackView.distribution = .equalCentering
//        //        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        return stackView
//    }()
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
        
//        let view = UIView()
//        view.backgroundColor = .darkGray
//
//        self.verticalStackView.frame = view.bounds
//        view.addSubview(self.verticalStackView)
//
//        self.verticalStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        self.verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        self.verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        self.verticalStackView.setContentCompressionResistancePriority(.required, for: .vertical)
//
//        for lineStackView in self.createLines() {
//            self.verticalStackView.addArrangedSubview(lineStackView)
//        }
//
//        view.setNeedsUpdateConstraints()
//        view.setNeedsLayout()
//
//        self.view = view
    }
    
    // MARK: - Creation
    
    //, fromColor startColor: UIColor, toColor endColor: UIColor
    func createSquares(ofSize size: CGSize) {
        let squares = Square.squares(fromColor: self.startColor, toColor: self.endColor, quantity: self.squarePerLine)
        for square in squares {
            let squareView = SquareView(square: square)
            squareView.frame.size = size
        }
    }
    
    func createSquares() -> [Square] {
        return Square.squares(fromColor: self.startColor, toColor: self.endColor, quantity: self.squarePerLine)
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
