//
//  UIImage+SFSymbols.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/2/25.
//

import UIKit

extension UIImage {
    enum Lock {
        enum Open {
            static let fill: UIImage = UIImage(systemName: "lock.open.fill")!
        }

        static let fill: UIImage = UIImage(systemName: "lock.fill")!
    }

    enum Arrow {
        static let circlePath = UIImage(systemName: "arrow.2.circlepath")!
    }

    enum Square {
        enum Grid {
            enum TwoByTwo {
                static let fill: UIImage = UIImage(systemName: "square.grid.2x2.fill")!
            }
        }
    }

    enum Characters {
        static let uppercase = UIImage(systemName: "characters.uppercase")!
    }

    enum Character {
        static let textbox = UIImage(systemName: "character.textbox")!
    }

    enum Clock {
        static let fill = UIImage(systemName: "clock.fill")!
    }
}
