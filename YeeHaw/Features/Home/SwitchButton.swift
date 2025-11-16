//
//  SwitchButton.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/5/25.
//

import UIKit

class SwitchButton: UIView {
    var action: () -> Void = {}
    var isEnabled: Bool {
        get {
            button.isEnabled
        }
        set {
            button.isEnabled = newValue
            if button.isEnabled {
                self.layer.opacity = 1.0
            } else {
                self.layer.opacity = 0.5
            }
        }
    }

    private let button = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let icon = {
        let image = UIImage.Arrow.circlePath
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBrown

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init() {
        super.init(frame: .zero)

        setupButton()
        setupIcon()
    }

    private func setupButton() {
        addSubview(button)

        button.pinToEdges(of: self)

        button.addAction( UIAction { _ in
            self.action()
        }, for: .touchUpInside)
        button.addAction(UIAction { [weak self] _ in
            self?.didPress()
        }, for: .touchDown)
        button.addAction(UIAction { [weak self] _ in
            self?.didRelease()
        }, for: [.touchUpInside, .touchUpOutside])
    }

    private func didPress() {
        self.layer.opacity = 0.5
    }

    private func didRelease() {
        self.layer.opacity = 1.0
    }

    private func setupIcon() {
        button.addSubview(icon)

        let verticalPadding: CGFloat = 3
        let minHorizontalPadding: CGFloat = 2
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: icon.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: icon.centerYAnchor),

            icon.topAnchor.constraint(equalTo: button.topAnchor, constant: verticalPadding),
            icon.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -verticalPadding),
            icon.leadingAnchor.constraint(greaterThanOrEqualTo: button.leadingAnchor, constant: minHorizontalPadding),
            icon.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor, constant: minHorizontalPadding)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        button.layer.cornerRadius = bounds.height / 2
    }
}

#Preview {
    let button = SwitchButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 70).isActive = true
    button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    button.action = {
        print("Tapped")
    }
    button.backgroundColor = .red

    return button
}
