//
//  ProminentButton.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/15/25.
//

import UIKit

class ProminentButton: UIView {
    var title: String = "" {
        didSet {
            label.text = title
        }
    }
    var action: () -> Void = { }

    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBrown.cgColor
        button.clipsToBounds = true

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .systemBrown
        label.textAlignment = .center
        label.numberOfLines = 1

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var impactGenerator = UIImpactFeedbackGenerator(style: .medium, view: self)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupButton()
        setupLabel()
    }

    private func setupButton() {
        self.addSubview(button)

        button.pinToEdges(of: self)

        button.addAction(UIAction { [weak self] _ in
            self?.impactGenerator.impactOccurred()
            self?.action()
        }, for: .touchUpInside)
        button.addAction(UIAction { [weak self] _ in
            self?.layer.opacity = 0.5
        }, for: .touchDown)
        button.addAction(UIAction { [weak self] _ in
            self?.layer.opacity = 1
        }, for: [.touchUpInside, .touchUpOutside])
    }

    private func setupLabel() {
        button.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: button.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor, constant: -20),
            label.topAnchor.constraint(greaterThanOrEqualTo: button.topAnchor, constant: 4),
            label.bottomAnchor.constraint(lessThanOrEqualTo: button.bottomAnchor, constant: 4)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        button.layer.cornerRadius = button.bounds.height / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    let button = ProminentButton(frame: .zero)
    button.title = "Play"
    button.action = {
        print("Play")
    }
    button.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: 200),
        button.heightAnchor.constraint(equalToConstant: 50),
    ])
    return button
}
