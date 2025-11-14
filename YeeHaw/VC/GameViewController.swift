//
//  GameViewController.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/3/25.
//

import UIKit
import Combine

class GameViewController: UIViewController {
    var gameVM: GameViewModel!

    // MARK: Views
    var gridVC: GridViewControlling!
    var bottomPanelVC: BottomPanelViewController!

    var sequenceBox: YeeHawSequenceBox!

    // MARK: Constraints
    var gridTopConstraint: NSLayoutConstraint!

    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown

        setupCards()
        setupAccessories()
        setupBottomPanel()
        addBottomPanelToView()
        setupSequenceBox()
    }

    // MARK: Setup

    private func setupCards() {
        gameVM = GameViewModel()
        gridVC = GridViewController(gameViewModel: gameVM)
        addChild(gridVC)

        view.addSubview(gridVC.view)

        gridVC.view.translatesAutoresizingMaskIntoConstraints = false

        gridTopConstraint = gridVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)

        NSLayoutConstraint.activate([
            gridTopConstraint,
            gridVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gridVC.view.widthAnchor.constraint(equalTo: gridVC.view.heightAnchor)
        ])
    }

    private func setupAccessories() {
        let refresh = UIBarButtonItem(systemItem: .refresh)
        refresh.target = self
        refresh.action = #selector(refreshTapped)

        self.navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarItems([
            refresh
        ], animated: false)
    }

    @objc
    func refreshTapped() {
        gameVM.restartGame()
        gridVC.cardsGridView.refresh()
    }

    private func setupBottomPanel() {
        self.bottomPanelVC = BottomPanelViewController(gameVM: gameVM)
        bottomPanelVC.playAction = {
            self.gameVM.restartGame()
            self.gameVM.generateSequences()
            self.prepareForGame()
        }

        bottomPanelVC.view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupSequenceBox() {
        sequenceBox = YeeHawSequenceBox(gameVM: gameVM)

        sequenceBox.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Update UI

    private func addBottomPanelToView() {
        self.addChild(bottomPanelVC)
        self.view.addSubview(bottomPanelVC.view)

        NSLayoutConstraint.activate([
            bottomPanelVC.view.topAnchor.constraint(equalTo: gridVC.view.bottomAnchor),
            bottomPanelVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanelVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanelVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func addSequenceBoxToView() {
        view.addSubview(sequenceBox)

        let heightConstraint = sequenceBox.heightAnchor.constraint(equalToConstant: 115)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            sequenceBox.topAnchor.constraint(equalTo: gridVC.view.bottomAnchor, constant: 5),
            sequenceBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sequenceBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sequenceBox.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            heightConstraint
        ])
    }

    private func prepareForGame() {
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: nil, image: .init(systemName: "ellipsis"), target: nil, action: nil), animated: true)

        self.bottomPanelVC.animateOutAndRemove()

        self.presentSequenceBox()

        UIView.animate(withDuration: 0.6) {
            self.gridTopConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    private func presentSequenceBox() {
        // Spring scale box from space between roles
        addSequenceBoxToView()

        sequenceBox.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(springDuration: 0.6, bounce: 0.3, delay: 0.3) {
            sequenceBox.transform = .identity
        } completion: { _ in
            // TODO: start game timer
        }
    }
}


#Preview {
    let navController = UINavigationController(rootViewController: GameViewController())
    return navController
}
