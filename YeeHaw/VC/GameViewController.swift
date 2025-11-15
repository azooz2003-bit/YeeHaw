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

    lazy var sequenceBox = YeeHawSequenceBox(gameVM: gameVM)
    lazy var gameInfoView = GameInfoView()

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

        gameVM.activeSymbolSubject.sink { [weak self] symbol in
            UIView.animate(withDuration: 0.2) {
                self?.gameInfoView.setActiveSymbol(symbol)
            }
        }
        .store(in: &cancellables)
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
        sequenceBox.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = sequenceBox.heightAnchor.constraint(equalToConstant: 60)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            sequenceBox.topAnchor.constraint(equalTo: gridVC.view.bottomAnchor, constant: 5),
            sequenceBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sequenceBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sequenceBox.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            heightConstraint
        ])
    }

    private func addGameInfoToView() {
        view.addSubview(gameInfoView)
        gameInfoView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gameInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gameInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            gameInfoView.bottomAnchor.constraint(lessThanOrEqualTo: gridVC.view.topAnchor, constant: -20),
        ])
    }

    private func prepareForGame() {
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: nil, image: .ellipsis, target: nil, action: nil), animated: true)

        self.bottomPanelVC.animateOutAndRemove()

        self.presentSequenceBox()
        self.presentGameInfoView()

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
            self.gameInfoView.startTimer(forSeconds: 60)
        }
    }

    private func presentGameInfoView() {
        addGameInfoToView()
        gameInfoView.setActiveSymbol(gameVM.activeSymbol)

        gameInfoView.transform = CGAffineTransform(translationX: -3, y: 0)
        UIView.animate(withDuration: 0.4) {
            self.gameInfoView.transform = .identity
        }
    }
}

extension GameViewController: GameInfoViewDelegate {
    func timerDidFinish() {
        // TODO: transition to end game screen
    }
}


#Preview {
    let navController = UINavigationController(rootViewController: GameViewController())
    return navController
}
