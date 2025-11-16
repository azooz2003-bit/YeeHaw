//
//  CardsGrid.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/4/25.
//

import UIKit

class CardsGrid: UIView {
    var gameVM: GameViewModel
    weak var cardDelegate: CardDelegate? {
        didSet {
            let cards = cardsGrid.reduce([], +)
            for card in cards {
                card.delegate = cardDelegate
            }
        }
    }
    private var gridStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        return stackView
    }()

    private var cardsGrid: [[Card]]

    init(cardDelegate: CardDelegate, gameVM: GameViewModel) {
        self.gameVM = gameVM
        self.cardDelegate = cardDelegate

        self.cardsGrid = (0..<gameVM.numRows).map { (i) in
            (0..<gameVM.numColumns).map { (j) in
                let card = Card()
                card.delegate = cardDelegate

                /*
                 e.g. numColumns = 3 ; i = 1 ; j = 2 => 3 * 1 + 2 = 5 (6th element)
                 */
                card.tag = gameVM.numColumns * i + j

                return card
            }
        }

        super.init(frame: .zero)

        self.refresh()
        self.setupGridStackView()
    }

    private func setupGridStackView() {
        for cardsRow in cardsGrid {
            let rowView = CardsRow()
            rowView.addCards(cardsRow)
            gridStackView.addArrangedSubview(rowView)
        }

        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(gridStackView)
        gridStackView.pinToEdges(of: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refresh() {
        guard case .inProgress(let grid) = gameVM.state else {
            for row in cardsGrid {
                for card in row {
                    card.configure(with: nil)
                }
            }
            return
        }

        for (i, row) in grid.enumerated() {
            for (j, cardSymbol) in row.enumerated() {
                let card = cardsGrid[i][j]
                card.configure(with: cardSymbol)
            }
        }
    }
}

#Preview {
    class MockDelegate: CardDelegate {
        var gameVM = GameViewModel()
        func didSelectCard(_ card: Card, at index: Int) {
            let indexPath = IndexPath(item: index, section: 0)
            let (row, col) = indexPath.twoDimIndex(numberOfColumns: gameVM.numColumns)

            let _ = gameVM.selectCard(at: indexPath)

            if let grid = gameVM.state.grid {
                card.configure(with: grid[row][col])
            }
        }
    }
    let delegate = MockDelegate()
    PreviewStrongReference.add(delegate)

    let gameVM = delegate.gameVM
    gameVM.restartGame()
    _ = gameVM.state.setSymbol(.yee, row: 0, col: 0)

    let cardsGridView = CardsGrid(cardDelegate: delegate, gameVM: gameVM)
    cardsGridView.heightAnchor.constraint(equalToConstant: 300).isActive = true

    return cardsGridView
}
