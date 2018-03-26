//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//// MARK: -
//public class GridViewController: UIViewController {
//
//    // MARK: - Properties
//
//    // MARK: Public
//    public var squarePerLine: Int = 5
//    public var lines: Int = 5
//
//    let verticalStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.alignment = .top
//        stackView.axis = .vertical
//        stackView.distribution = .equalSpacing
//
//        return stackView
//    }()
//
//    // MARK: - UIViewController Overrides
//
//    public override func loadView() {
//        let view = UIView()
//        view.backgroundColor = .darkGray
//
//        view.addSubview(self.verticalStackView)
//
//        for lineStackView in self.createLines() {
//            self.verticalStackView.addArrangedSubview(lineStackView)
//        }
//
//        self.view = view
//    }
//
//    // MARK: -
//
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
//        return (0..<self.squarePerLine).map({ SquareView(square: Square(color: .purple, correctPosition: $0)) })
//    }
//
//}
//
//struct Square {
//    var color: UIColor
//    var correctPosition: Int
//}
//
//class SquareView: UIView {
//
//    let square: Square
//
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: 10, height: 10)
//    }
//
//    init(square: Square) {
//        self.square = square
//        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//
//        self.backgroundColor = square.color
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        return nil
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.layer.borderColor = UIColor.white.cgColor
//        self.layer.borderWidth = 0.5
//    }
//
//}
//
//// Present the view controller in the Live View window
//let viewController = GridViewController()
////viewController.view.frame =
//PlaygroundPage.current.liveView = viewController

