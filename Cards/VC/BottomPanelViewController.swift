//
//  BottomPanelViewController.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 11/2/25.
//

import UIKit
import Combine

class BottomPanelViewController: UIViewController {

    var rolesToggle: SwitchButton!

    var symbolRolesStackView: UIStackView!
    var evenSymbolSection: SubjectToRoleView!
    var oddSymbolSection: SubjectToRoleView!

    var playButton: ProminentButton!

    var gameVM: GameViewModel
    var playAction: (() -> Void)!

    var cancellables: Set<AnyCancellable> = []

    init(gameVM: GameViewModel) {
        self.gameVM = gameVM

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRolesSection()
        setupPlayButton()

        gameVM.activeSymbolSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] activeSymbol in
                guard let self else { return }

                self.evenSymbolSection.value = activeSymbol.label
                self.oddSymbolSection.value = activeSymbol.opposite().label
            }
            .store(in: &cancellables)
    }

    private func setupRolesSection() {
        // Roles Toggle

        self.rolesToggle = SwitchButton()
        rolesToggle.action = { [weak self] in
            self?.gameVM.switchActiveSymbol()
            self?.configureRoles()
        }

        view.addSubview(rolesToggle)
        rolesToggle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rolesToggle.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            rolesToggle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rolesToggle.widthAnchor.constraint(equalToConstant: 70),
            rolesToggle.heightAnchor.constraint(equalToConstant: 25)
        ])

        // Player roles

        let (p1Symbol, p2Symbol) = getSymbolRoles()

        evenSymbolSection = SubjectToRoleView()
        evenSymbolSection.attributeName = String(localized: "Even")
        evenSymbolSection.value = p1Symbol.label

        oddSymbolSection = SubjectToRoleView(frame: .zero)
        oddSymbolSection.attributeName = String(localized: "Odd")
        oddSymbolSection.value = p2Symbol.label

        symbolRolesStackView = UIStackView(arrangedSubviews: [
            evenSymbolSection,
            oddSymbolSection,
        ])
        symbolRolesStackView.axis = .horizontal
        symbolRolesStackView.spacing = 50
        symbolRolesStackView.alignment = .fill
        symbolRolesStackView.distribution = .equalSpacing

        view.addSubview(symbolRolesStackView)
        symbolRolesStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            symbolRolesStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 100),
            symbolRolesStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -100),
            symbolRolesStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            symbolRolesStackView.topAnchor.constraint(equalTo: rolesToggle.bottomAnchor, constant: 20)
        ])
    }

    private func configureRoles() {
        let (evenSymbol, oddSymbol) = getSymbolRoles()

        evenSymbolSection.value = evenSymbol.label
        oddSymbolSection.value = oddSymbol.label
    }

    private func getSymbolRoles() -> (even: CardSymbol, odd: CardSymbol) {
        let symbol = gameVM.activeSymbol
        return (symbol, symbol.opposite())
    }

    private func setupPlayButton() {
        self.playButton = ProminentButton(frame: .zero)
        playButton.title = "Play"
        playButton.action = playAction

        playButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(playButton)

        let heightConstraint = playButton.heightAnchor.constraint(equalToConstant: 60)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            playButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            playButton.topAnchor.constraint(equalTo: symbolRolesStackView.bottomAnchor, constant: 15),
            heightConstraint,
            playButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -5),
        ])
    }

    func animateOutAndRemove() {
        UIView.animate(withDuration: 0.6) {
            self.evenSymbolSection.transform = CGAffineTransform(translationX: -150, y: 0)
            self.evenSymbolSection.layer.opacity = 0.0

            self.oddSymbolSection.transform = CGAffineTransform(translationX: 150, y: 0)
            self.oddSymbolSection.layer.opacity = 0.0

            self.rolesToggle.layer.opacity = 0.0

            self.playButton.transform = CGAffineTransform(translationX: 0, y: 250)

        } completion: { finished in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
