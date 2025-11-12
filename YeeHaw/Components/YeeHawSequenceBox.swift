//
//  YeeHawSequenceBox.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 11/1/25.
//

import UIKit

class YeeHawSequenceBox: UIView {

    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withProminence(.secondary)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var viewModeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.addAction(UIAction { [weak self] _ in
            self?.displayAll.toggle()
        }, for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var displayAll: Bool = false {
        didSet {
            if displayAll {
                viewModeButton.setImage(.Characters.uppercase, for: .normal)
            } else {
                viewModeButton.setImage(.Square.Grid.TwoByTwo.fill, for: .normal)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupContainer()
        setupViewModeButton()
    }

    private func setupContainer() {
        self.addSubview(container)

        container.pinToEdges(of: self)
    }

    private func setupViewModeButton() {
        container.addSubview(viewModeButton)

        displayAll = false

        NSLayoutConstraint.activate([
            viewModeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
            viewModeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

#Preview {
    let view = UIView()
    view.backgroundColor = .red
    view.frame = .init(x: 0, y: 0, width: 500, height: 500)

    let box = YeeHawSequenceBox(frame: .zero)
    box.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(box)

    NSLayoutConstraint.activate([
        box.widthAnchor.constraint(equalToConstant: 250),
        box.heightAnchor.constraint(equalToConstant: 100),
        box.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        box.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])


    return view
}
