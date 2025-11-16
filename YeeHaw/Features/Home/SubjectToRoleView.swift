//
//  SubjectToRoleView.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/14/25.
//

import UIKit

class SubjectToRoleView: UIView {
    var attributeName: String = "" {
        didSet {
            attributeLabel.text = attributeName
        }
    }
    var value: String = "" {
        didSet {
            valueLabel.text = value
        }
    }

    // MARK: Views
    private lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override var intrinsicContentSize: CGSize {
        let width = max(valueLabel.intrinsicContentSize.width, attributeLabel.intrinsicContentSize.width)
        return CGSize(width: width, height: super.intrinsicContentSize.height)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupAttributeLabel()
        setupDivider()
        setupValueLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAttributeLabel() {
        attributeLabel.text = attributeName

        self.addSubview(attributeLabel)

        NSLayoutConstraint.activate([
            attributeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            attributeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            attributeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    private func setupDivider() {
        self.addSubview(divider)

        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.widthAnchor.constraint(equalTo: attributeLabel.widthAnchor),
            divider.topAnchor.constraint(equalTo: attributeLabel.bottomAnchor, constant: 4),
            divider.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    private func setupValueLabel() {
        valueLabel.text = value

        self.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 6),
            valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

#Preview {
    let view = SubjectToRoleView(frame: .zero)
    view.attributeName = "Player 1"
    view.value = "Yee"
    view.backgroundColor = .red
    return view
}
