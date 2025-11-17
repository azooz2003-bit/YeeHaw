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
        static let gridTopPadding: CGFloat = 30
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

        setupGameInfo()
        setupCards()
        setupSequenceBox()

        gameVM.activeSymbolSubject.sink { [weak self] symbol in
            UIView.animate(withDuration: 0.2) {
                self?.gameInfoView.setActiveSymbol(symbol)
            }
        }
        .store(in: &cancellables)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameInfoView.startTimer(forSeconds: 60)
    }

    // MARK: Setup

    private func setupGameInfo() {
        gameInfoView.setActiveSymbol(gameVM.activeSymbol)
        gameInfoView.placeholderTime = 60

        view.addSubview(gameInfoView)
        gameInfoView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gameInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gameInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
        ])
    }

    private func setupCards() {
        addChild(gridVC)
        view.addSubview(gridVC.view)

        gridVC.view.translatesAutoresizingMaskIntoConstraints = false

        gridTopConstraint = gridVC.view.topAnchor.constraint(equalTo: gameInfoView.bottomAnchor, constant: Constants.gridTopPadding)
        NSLayoutConstraint.activate([
            gridTopConstraint,
            gridVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gridVC.view.widthAnchor.constraint(equalTo: gridVC.view.heightAnchor)
        ])
    }

    private func setupSequenceBox() {
        view.addSubview(sequenceBox)
        sequenceBox.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = sequenceBox.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            sequenceBox.topAnchor.constraint(equalTo: gridVC.view.bottomAnchor, constant: Constants.sequenceBoxTopPadding),
            sequenceBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sequenceBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sequenceBox.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            heightConstraint
        ])
    }
}

extension GameViewController: GameInfoViewDelegate {
    func timerDidFinish() {
        // TODO: transition to game over
    }
}

#Preview {
    let vm = GameViewModel()
    let gameVC = GameViewController(gameVM: vm)
    vm.generateSequences()
    vm.restartGame()
    vm.selectCard(at: .init(item: 4, section: 0))

    return gameVC
}
