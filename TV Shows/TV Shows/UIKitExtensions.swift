//
//  UIKitExtensions.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 29.7.23.
//

import Foundation
import UIKit

extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPointMake(self.center.x - 10, self.center.y))
        animation.toValue = NSValue(cgPoint: CGPointMake(self.center.x + 10, self.center.y))
        self.layer.add(animation, forKey: "position")
      }
}
