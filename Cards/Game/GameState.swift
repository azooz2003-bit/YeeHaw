//
//  GameState.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 11/1/25.
//

import Foundation

enum GameState: Equatable {
    case idle, inProgress([[CardSymbol?]]), finished

    var grid: [[CardSymbol?]]? {
        switch self {
        case .inProgress(let grid):
            grid
        default:
            nil
        }
    }

    mutating func setSymbol(_ symbol: CardSymbol?, row: Int, col: Int) -> Bool {
        switch self {
        case .inProgress(var grid):
            grid[row][col] = symbol
            self = .inProgress(grid)
            return true
        default:
            return false
        }
    }
}
