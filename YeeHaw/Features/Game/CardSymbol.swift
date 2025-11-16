//
//  CardSymbol.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 11/1/25.
//

import UIKit

enum CardSymbol: String {
    case yee = "Yee", haw = "Haw"

    var label: String { rawValue }

    func opposite() -> Self {
        switch self {
        case .yee:
            .haw
        case .haw:
            .yee
        }
    }

    var color: UIColor {
        switch self {
        case .yee:
            .systemOrange
        case .haw:
            .systemYellow
        }
    }
}
