import Foundation
import UIKit

public class GridViewController: UIViewController {
    
    public var squarePerLine: Int = 10
    public var lines: Int = 10
    
    let stackView = UIStackView()
    
    public override func loadView() {
        let view = UIView()
        view.backgroundColor = .darkGray
        
        
        
        self.view = view
    }

    
}
