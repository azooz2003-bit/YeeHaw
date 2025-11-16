//
//  GameViewController.swift
//  YeeHaw
//
//  Created by Abdulaziz Albahar on 11/15/25.
//

import UIKit
import Combine

class GameViewController: UIViewController {
    enum Constants {
        static let gridTopPadding: CGFloat = 50
        static let sequenceBoxTopPadding: CGFloat = 5
    }
    var gameVM: GameViewModel

    // MARK: Views
    lazy var gridVC = GridViewController(gameViewModel: gameVM)
    lazy var sequenceBox = YeeHawSequenceBox(gameVM: gameVM)
    lazy var gameInfoView = GameInfoView()
    
    // MARK: Constraints
    var gridTopConstraint: NSLayoutConstraint!

    var cancellables: Set<AnyCancellable> = []

    init(gameVM: GameViewModel) {
        self.gameVM = gameVM

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        navigationItem.hidesBackButton = true

        setupCards()
        setupSequenceBox()
        setupGameInfo()

        gameVM.activeSymbolSubject.sink { [weak self] symbol in
            UIView.animate(withDuration: 0.2) {
                self?.gameInfoView.setActiveSymbol(symbol)
            }
        }
        .store(in: &cancellables)
    }

    // MARK: Setup

    private func setupCards() {
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

    // MARK: Update UI

    private func setupSequenceBox() {
        view.addSubview(sequenceBox)
        sequenceBox.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = sequenceBox.heightAnchor.constraint(equalToConstant: 60)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            sequenceBox.topAnchor.constraint(equalTo: gridVC.view.bottomAnchor, constant: Constants.sequenceBoxTopPadding),
            sequenceBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sequenceBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sequenceBox.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            heightConstraint
        ])
    }

    private func setupGameInfo() {
        gameInfoView.setActiveSymbol(gameVM.activeSymbol)

        view.addSubview(gameInfoView)
        gameInfoView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gameInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gameInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            gameInfoView.bottomAnchor.constraint(lessThanOrEqualTo: gridVC.view.topAnchor, constant: -20),
        ])
    }
}

extension GameViewController: GameInfoViewDelegate {
    func timerDidFinish() {
        // TODO: transition to game over
    }
}
