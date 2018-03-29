//
//  GridViewController.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 25/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import Foundation
import UIKit
//import PlaygroundSupport

public class Grid {
    public var startColor: UIColor = .purple        { didSet { self._rows = nil } }
    public var endColor: UIColor = .green           { didSet { self._rows = nil } }
    public var amountOfHorizontalLines: Int = 15    { didSet { self._rows = nil } }
    public var amountOfVerticalSquares: Int = 20    { didSet { self._rows = nil } }
    public var delayBetweenUpdates: TimeInterval = 0.01
    
    public var sorter: Sorter = QuickSort()
    
    let gridView = GridViewController()
    
    var _rows: [Row]?
    var rows: [Row] {
        if let rows = self._rows { return rows }
        
        var lines = [Row]()
        for _ in (0..<self.amountOfHorizontalLines) {
            var line = Row(fromColor: self.startColor, toColor: self.endColor, quantity: self.amountOfVerticalSquares)
            line.shuffle()
            lines.append(line)
        }
        self._rows = lines
        return lines
    }
    
    public init(startColor: UIColor, endColor: UIColor, amountOfHorizontalLines: Int, amountOfVerticalSquares: Int) {
        self.startColor = startColor
        self.endColor = endColor
        self.amountOfHorizontalLines = amountOfHorizontalLines
        self.amountOfVerticalSquares = amountOfVerticalSquares
    }
    
    public init() {}
    
    private func show() {
        self.gridView.updateLayout(withRows: self.rows)
//        PlaygroundPage.current.liveView = self.gridView
    }
    
    // MARK: SORTING
    
    private let updateOperations: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }()

    func sort() {
        self.show()
        
        for (index, row) in self.rows.enumerated() {
            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 2) {
                self.sorter.sortSquares(row.blocks, updateRowWith: { (blocks) in
                    let updateOperation = BlockOperation {
                        DispatchQueue.main.async {
                            self.gridView.updateRow(at: index, withRow: Row(squares: blocks))
                        }
                    }
                    self.updateOperations.addOperation(DelayOperation(self.delayBetweenUpdates))
                    self.updateOperations.addOperation(updateOperation)
                })
            }
        }
        
    }
    
}

class GridViewController: UIViewController {
    
    // MARK: - Properties
    
//    // MARK: Public
//
//    public private(set) unowned var grid: Grid

    // MARK: Private
    
    private var lineViews: [LineView] {
        return self.view.subviews.flatMap({ $0 as? LineView })
    }
    
    // MARK: - Contructors
    
//    init(withGrid grid: Grid) {
//        super.init(nibName: nil, bundle: nil)
//        
//        self.updateLayout(withRows: grid.rows)
//    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: - UIViewController Overrides
    
    public override func loadView() {
        let view = UIView()
        
        view.backgroundColor = .darkGray

        self.view = view
    }
    
    public override func viewDidLayoutSubviews() {
        self.layoutRows()
        
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Line Managment
    
    // MARK: Internal
    
    func updateLayout(withRows rows: [Row]) {
        self.lineViews.forEach({ $0.removeFromSuperview() })
        
        for row in rows {
            self.view.addSubview(LineView(withRow: row))
        }
        
        self.view.setNeedsLayout()
    }
    
    func updateRow(at index: Int, withRow row: Row) {
        self.lineViews[index].line = row
    }

    // MARK: Private
    
    private func layoutRows() {
        let lineHeight = self.view.bounds.height / CGFloat(self.lineViews.count)
        for (index, lineView) in self.lineViews.enumerated() {
            lineView.frame.origin.y = lineHeight * CGFloat(index)
            lineView.frame.size.height = lineHeight
            lineView.frame.size.width = self.view.bounds.width
        }
    }
    
    private func createLineViews(forRows rows: [Row]) -> [LineView] {
        return rows.map({ LineView(withRow: $0) })
    }
    
}
