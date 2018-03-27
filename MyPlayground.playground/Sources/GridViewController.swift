//
//  GridViewController.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 25/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import Foundation
import UIKit

public class GridViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: Public
    
    public private(set) var grid: Grid

    // MARK: Private
    
    private var lineViews: [LineView] {
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
    
    // MARK: - Contructors
    
    public init(withGrid grid: Grid) {
        self.grid = grid
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: - UIViewController Overrides
    
    public override func loadView() {
        let view = UIView()
        view.backgroundColor = .darkGray


        for lineStackView in self.createLines() {
            view.addSubview(lineStackView)
        }

        self.view = view
        
        self.layoutLines()
    }
    
    public override func viewDidLayoutSubviews() {
        self.layoutLines()
        
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Line Managment
    
    private func layoutLines() {
        let lineHeight = self.view.bounds.height / CGFloat(self.grid.amountOfHorizontalLines)
        for (index, lineView) in self.lineViews.enumerated() {
            lineView.frame.origin.y = lineHeight * CGFloat(index)
            lineView.frame.size.height = lineHeight
            lineView.frame.size.width = self.view.bounds.width
        }
    }
    
    private func createLines() -> [LineView] {
        var lineViews = [LineView]()
        for line in self.grid.lines {
            let lineView = LineView(withLine: line)
            lineViews.append(lineView)
        }
        return lineViews
    }
    
}
