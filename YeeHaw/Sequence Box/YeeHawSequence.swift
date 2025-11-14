//
//  YeeHawSequence.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 11/1/25.
//

import UIKit
import Foundation

struct YeeHawSequence {
    struct Position: Equatable {
        let row: Int
        let col: Int
    }

    enum CompletionStatus: Equatable {
        case incomplete, complete([Position])

        var isComplete: Bool {
            switch self {
            case .incomplete: return false
            case .complete: return true
            }
        }

        static func == (lhs: YeeHawSequence.CompletionStatus, rhs: YeeHawSequence.CompletionStatus) -> Bool {
            switch (lhs, rhs) {
            case (.incomplete, .incomplete):
                return true
            case (.complete(let lhsPositions), .complete(let rhsPositions)):
                return lhsPositions == rhsPositions
            default: return false
            }
        }
    }
    

    var symbols: (CardSymbol, CardSymbol, CardSymbol)
    var color: UIColor
    var completionStatus: CompletionStatus

    func label() -> String {
        [
            symbols.0,
            symbols.1,
            symbols.2
        ].map(\.label).joined()
    }
}

extension YeeHawSequence: Equatable {
    static func == (lhs: YeeHawSequence, rhs: YeeHawSequence) -> Bool {
        lhs.symbols == rhs.symbols && lhs.color == rhs.color && lhs.completionStatus == rhs.completionStatus
    }
}
