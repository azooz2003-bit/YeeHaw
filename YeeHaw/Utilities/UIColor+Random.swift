//
//  UIColor+Random.swift
//  YeeHaw
//
//  Created by Abdulaziz Albahar on 11/13/25.
//

import UIKit

extension UIColor {
    /// Generates a random dark color
    static func randomDark() -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...0.4),
            green: CGFloat.random(in: 0...0.4),
            blue: CGFloat.random(in: 0...0.4),
            alpha: 1.0
        )
    }
}
