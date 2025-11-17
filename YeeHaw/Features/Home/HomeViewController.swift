//
//  HomeViewController.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/3/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    enum Constants {
        static let gridTopPadding: CGFloat = 0
    }
    var gameVM: GameViewModel!

    // MARK: Views
    var gridVC: GridViewControlling!
    var bottomPanelVC: BottomPanelViewController!

    var gridTopConstraint: NSLayoutConstraint!

    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        navigationItem.hidesBackButton = true

        setupCards()
        setupBottomPanel()
    }

    // MARK: Setup

    private func setupCards() {
        gameVM = GameViewModel()
        gridVC = GridViewController(gameViewModel: gameVM)
        
        addChild(gridVC)
        view.addSubview(gridVC.view)

        gridVC.view.translatesAutoresizingMaskIntoConstraints = false

        gridTopConstraint = gridVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.gridTopPadding)

        NSLayoutConstraint.activate([
            gridTopConstraint,
            gridVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gridVC.view.widthAnchor.constraint(equalTo: gridVC.view.heightAnchor)
        ])
    }

    private func setupBottomPanel() {
        self.bottomPanelVC = BottomPanelViewController(gameVM: gameVM)
        bottomPanelVC.playAction = {
            self.gameVM.restartGame()
            self.gameVM.generateSequences()

            let gameVC = GameViewController(gameVM: self.gameVM)
            self.navigationController?.pushViewController(gameVC, animated: true)
        }

        bottomPanelVC.view.translatesAutoresizingMaskIntoConstraints = false

        self.addChild(bottomPanelVC)
        self.view.addSubview(bottomPanelVC.view)

        NSLayoutConstraint.activate([
            bottomPanelVC.view.topAnchor.constraint(equalTo: gridVC.view.bottomAnchor),
            bottomPanelVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanelVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanelVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

#Preview {
    let navController = UINavigationController(rootViewController: HomeViewController())
    return navController
}
