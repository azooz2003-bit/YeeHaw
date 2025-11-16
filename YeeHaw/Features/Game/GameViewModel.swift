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
    let numRows: Int = 3

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

    var sequences = CurrentValueSubject<[YeeHawSequence], Never>([])
    var currentSequence: AnyPublisher<YeeHawSequence?, Never> {
        sequences
            .map {
                $0.first { sequence in
                    switch sequence.completionStatus {
                    case .incomplete:
                        return true
                    case .complete(_):
                        return false
                    }
                }
            }
            .eraseToAnyPublisher()
    }

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

            if currentSequenceIsAchieved() {
                markCompletedSequences()
                // TODO: end game if all done
            }

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

    func generateSequences() {
        // TODO: make it less random

        var sequenceOptions = Set<String>()
        var visited = Set<String>()

        exploreNewSequences(discovered: &sequenceOptions, visited: &visited, currentSequence: "")

        let sequenceOptionsArr = Array(sequenceOptions)

        let result = sequenceOptionsArr.shuffled().compactMap {
            let split = $0.splitIntoChunks(ofLength: 3)
            guard let symbols = (CardSymbol(rawValue: split[0]), CardSymbol(rawValue: split[1]), CardSymbol(rawValue: split[2])) as? (CardSymbol, CardSymbol, CardSymbol) else { return nil }

            return YeeHawSequence(symbols: symbols, color: .randomDark(), completionStatus: .incomplete)
        } as [YeeHawSequence]

        // Make sure all strings were translated into `CardSymbol` properly
        guard result.count == sequenceOptionsArr.count else {
            return
        }

        self.sequences.send(result)
    }

    // MARK: Helpers

    private func exploreNewSequences(discovered: inout Set<String>, visited: inout Set<String>, currentSequence: String) {
        if currentSequence.count == 9 {
            discovered.insert(currentSequence)
        }

        // TODO: optimize by tracking visited
        guard currentSequence.count < 9 && !visited.contains(currentSequence) else {
            return
        }

        exploreNewSequences(discovered: &discovered, visited: &visited, currentSequence: currentSequence + "Yee")
        exploreNewSequences(discovered: &discovered, visited: &visited, currentSequence: currentSequence + "Haw")
    }

    /// Marks all contiguous sequences that have been achieved starting from `self.currentSequence`
    private func markCompletedSequences() {
        var currSequences = sequences.value

        while currentSequenceIsAchieved() {
            guard let activeSequenceIndex = currSequences.firstIndex (where: { !$0.completionStatus.isComplete }) else { return }

            // TODO: properly set positions
            currSequences[activeSequenceIndex].completionStatus = .complete([])

            sequences.send(currSequences)
        }
    }

    private func currentSequenceIsAchieved() -> Bool {
        guard let gridState = state.grid else { return false }
        guard let currentSequence = sequences.value.first(where: { !$0.completionStatus.isComplete }) else { return false }
        let currentSequenceArr = [currentSequence.symbols.0, currentSequence.symbols.1, currentSequence.symbols.2]

        // Check horizontal rows
        for row in 0..<numRows {
            if gridState[row].enumerated().allSatisfy({ (i, symbol) in
                symbol == currentSequenceArr[i]
            }) {
                return true
            }
        }

        // Check vertical columns
        for col in 0..<numColumns {
            let column = (0..<numRows).map { gridState[$0][col] }
            if column.enumerated().allSatisfy({ (i, symbol) in
                symbol == currentSequenceArr[i]
            }) {
                return true
            }
        }

        // Check main diagonal
        let mainDiagonal = (0..<numRows).map { gridState[$0][$0] }
        if mainDiagonal.enumerated().allSatisfy({ (i, symbol) in
            symbol == currentSequenceArr[i]
        }) {
            return true
        }

        // Check anti-diagonal
        let antiDiagonal = (0..<numRows).map { gridState[$0][numRows - 1 - $0] }
        if antiDiagonal.enumerated().allSatisfy({ (i, symbol) in
            symbol == currentSequenceArr[i]
        }) {
            return true
        }

        return false
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
