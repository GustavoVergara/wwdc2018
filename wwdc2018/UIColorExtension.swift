//
//  UIColorExtension.swift
//  wwdc2018
//
//  Created by Gustavo Vergara Garcia on 25/03/18.
//  Copyright © 2018 Gustavo Vergara Garcia. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    var redComponent: CGFloat {
        return self.getRGBAComponents()?.red ?? 0
    }
    
    var greenComponent: CGFloat {
        return self.getRGBAComponents()?.green ?? 0
    }

    var blueComponent: CGFloat {
        return self.getRGBAComponents()?.blue ?? 0
    }
    
    var alpha: CGFloat {
        return self.getRGBAComponents()?.alpha ?? 0
    }
    
    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue, alpha)
        } else {
            return nil
        }
    }
    
    func getHSBAComponents() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)? {
        var (hue, saturation, brightness, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return (hue, saturation, brightness, alpha)
        } else {
            return nil
        }
    }

    func getGrayscaleComponents() -> (white: CGFloat, alpha: CGFloat)? {
        var (white, alpha) = (CGFloat(0.0), CGFloat(0.0))
        if self.getWhite(&white, alpha: &alpha) {
            return (white, alpha)
        } else {
            return nil
        }
    }
    
    static func color(from startColor: UIColor, to endColor: UIColor, at percentage: CGFloat) -> UIColor {
        let resultantRed = startColor.redComponent + percentage * (endColor.redComponent - startColor.redComponent)
        let resultantGreen = startColor.greenComponent + percentage * (endColor.greenComponent - startColor.greenComponent)
        let resultantBlue = startColor.blueComponent + percentage * (endColor.blueComponent - startColor.blueComponent)
        let resultantAlpha = startColor.alpha + percentage * (endColor.alpha - startColor.alpha)
        
        return UIColor(red: resultantRed, green: resultantGreen, blue: resultantBlue, alpha: resultantAlpha)
    }
    
    static func colors(from startColor: UIColor, to endColor: UIColor, quantity: Int) -> [UIColor] {
        guard quantity >= 2 else { return [] }
        
        var returnValue = [UIColor]()
        let step = (CGFloat(quantity) / (CGFloat(quantity) - 1))
        for index in 0..<quantity {
            returnValue.append(.color(from: startColor, to: endColor, at: (CGFloat(index) * step) / CGFloat(quantity)))
        }
        
        return returnValue
    }

}
