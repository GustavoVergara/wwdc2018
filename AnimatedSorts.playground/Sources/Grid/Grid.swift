//
//  GridViewController.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 25/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import Foundation
import UIKit
import PlaygroundSupport

public class Grid {
//    public var startColor: UIColor = .purple        { didSet { self._rows = nil } }
//    public var endColor: UIColor = .green           { didSet { self._rows = nil } }
    public var amountOfRows: Int = 5                { didSet { self._rows = nil } }
    public var amountOfBlocksPerRow: Int = 70       { didSet { self._rows = nil } }
    public var delayBetweenUpdates: TimeInterval = 0.005
    
    public var sorter: Sorter = MergeSorter()
    
    let gridView = GridViewController()
    
    var _rows: [Row]?
    var rows: [Row] {
        if let rows = self._rows { return rows }
        
        var lines = [Row]()
        for _ in (0..<self.amountOfRows) {
            var line = Row(quantity: self.amountOfBlocksPerRow)
            line.shuffle()
            lines.append(line)
        }
        self._rows = lines
        return lines
    }
    
    public init(/*startColor: UIColor, endColor: UIColor, */amountOfRows: Int, amountOfBlocksPerRow: Int) {
//        self.startColor = startColor
//        self.endColor = endColor
        self.amountOfRows = amountOfRows
        self.amountOfBlocksPerRow = amountOfBlocksPerRow
    }
    
    public init() {}
    
    private func show() {
        self.gridView.updateLayout(withRows: self.rows)
        PlaygroundPage.current.liveView = self.gridView
    }
    
    // MARK: SORTING
    
    private let updateOperations: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }()

    public func sort() {
        self.show()
        
        for (index, row) in self.rows.enumerated() {
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
                self.sorter.sortRow(row, updateRowTo: { (newRow) in
                    let updateOperation = BlockOperation {
                        DispatchQueue.main.async {
                            self.gridView.updateRow(at: index, withRow: newRow)
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
    
    private var lineViews: [HorizontalRowView] {
        return self.view.subviews.compactMap({ $0 as? HorizontalRowView })
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
            self.view.addSubview(HorizontalRowView(withRow: row))
        }
        
        self.view.setNeedsLayout()
    }
    
    func updateRow(at index: Int, withRow row: Row) {
        self.lineViews[index].row = row
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
    
    private func createLineViews(forRows rows: [Row]) -> [HorizontalRowView] {
        return rows.map({ HorizontalRowView(withRow: $0) })
    }
    
}
