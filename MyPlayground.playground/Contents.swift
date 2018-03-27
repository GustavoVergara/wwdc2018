//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

var grid = Grid()

grid.startColor = .yellow
grid.endColor = .green

PlaygroundPage.current.liveView = GridViewController(withGrid: grid)

