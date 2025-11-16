//
//  CardsViewController.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/2/25.
//

import UIKit

protocol GridViewControlling: UIViewController {
    var cardsGridView: CardsGrid! { get set }
    var viewModel: GameViewModel { get set }

    init(gameViewModel: GameViewModel)
}

class GridViewController: UIViewController, GridViewControlling {
    var cardsGridView: CardsGrid!
    var viewModel: GameViewModel

    required init(gameViewModel: GameViewModel) {
        self.viewModel = gameViewModel

        super.init(nibName: nil, bundle: nil)

        setupCardsGrid()
    }

    private func setupCardsGrid() {
        cardsGridView = CardsGrid(cardDelegate: self, gameVM: viewModel)

        cardsGridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardsGridView)
        cardsGridView.pinToEdges(of: self.view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GridViewController: CardDelegate {
    func didSelectCard(_ card: Card, at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let success = viewModel.selectCard(at: indexPath)

        let (row, col) = indexPath.twoDimIndex(numberOfColumns: viewModel.numColumns)
        if success, case .inProgress(let grid) = viewModel.state {
            card.configure(with: grid[row][col])
        }
    }
}
