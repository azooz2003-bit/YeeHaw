//
//  GameViewModel.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/2/25.
//

import Combine
import UIKit

class GameViewModel {
    var stateSubject: CurrentValueSubject<GameState, Never> = .init(.idle)
    var state: GameState {
        get {
            stateSubject.value
        } set {
            stateSubject.send(newValue)
        }
    }

    let numColumns: Int = 3
    var numRows: Int = 3

    var gameHasFinished: AnyPublisher<Bool, Never> {
        stateSubject
            .map { state in
                state == .finished
            }
            .eraseToAnyPublisher()
    }

    var activeSymbolSubject = CurrentValueSubject<CardSymbol, Never>(.yee)
    var activeSymbol: CardSymbol {
        get {
            activeSymbolSubject.value
        }
        set {
            activeSymbolSubject.send(newValue)
        }
    }

    var completedSequences = CurrentValueSubject<[YeeHawSequence], Never>([])

    var currentSequence = CurrentValueSubject<YeeHawSequence?, Never>(nil)

    /**
     Modifies the game state based on selecting the card at `indexPath`.
     - Returns: Whether the selection was accepted
     */
    @discardableResult
    func selectCard(at indexPath: IndexPath) -> Bool {
        guard let gridState = state.grid else {
            return false
        }

        let numCols = gridState[0].count
        let (row, col) = indexPath.twoDimIndex(numberOfColumns: numCols)

        if gridState[row][col] != nil {
            // Ignore selection
            return false
        } else {
            let success = state.setSymbol(activeSymbol, row: row, col: col)
            switchActiveSymbol()
            return success
        }
    }

    func switchActiveSymbol() {
        self.activeSymbol = activeSymbol.opposite()
    }

    func restartGame() {
        let grid: [[CardSymbol?]] = (0..<numRows).map { _ in
            (0..<numColumns).map { _ in nil }
        }

        state = .inProgress(grid)
    }
}

extension IndexPath {
    func twoDimIndex(numberOfColumns: Int) -> (row: Int, col: Int) {
        let index = self.row

        let col = index % numberOfColumns
        let row = index / numberOfColumns

        return (row, col)
    }
}
