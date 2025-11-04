//
//  CardSymbol.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 11/1/25.
//


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
}