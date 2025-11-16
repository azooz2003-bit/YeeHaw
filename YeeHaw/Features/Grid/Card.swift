//
//  Card.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/4/25.
//

import UIKit
import SwiftUI

protocol CardDelegate: AnyObject {
    func didSelectCard(_ card: Card, at index: Int)
}

class Card: UIView {
    struct ContainerConstraints {
        var top: NSLayoutConstraint
        var bottom: NSLayoutConstraint
        var trailing: NSLayoutConstraint
        var leading: NSLayoutConstraint

        mutating func changeTo(_ amount: CGFloat) {
            self.top.constant = amount
            self.bottom.constant = -amount
            self.trailing.constant = -amount
            self.leading.constant = amount
        }
    }

    private var symbol: CardSymbol?
    weak var delegate: CardDelegate?

    private var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    private var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private var lockSymbol: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1), // 1:1 aspect ratio
            imageView.widthAnchor.constraint(equalToConstant: 18),
        ])

        return imageView
    }()
    private var containerConstraints: ContainerConstraints!
    private lazy var feedbackGenerator = UIImpactFeedbackGenerator(style: .light, view: self)

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupContainer()

        setupSymbol()

        setupLock()

        setupGestureRecognizer()
    }

    // MARK: UI Setup

    private func setupContainer() {
        self.addSubview(containerView)

        self.containerConstraints = ContainerConstraints(
            top: self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            bottom: self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            trailing: self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            leading: self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0)
        )
        NSLayoutConstraint.activate([
            containerConstraints.top,
            containerConstraints.leading,
            containerConstraints.trailing,
            containerConstraints.bottom,
        ])
    }

    private func setupSymbol() {
        self.addSubview(symbolLabel)

        NSLayoutConstraint.activate([
            symbolLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            symbolLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            symbolLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            symbolLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
    }

    private func setupLock() {
        self.addSubview(lockSymbol)

        let lockPadding: CGFloat = 8
        NSLayoutConstraint.activate([
            lockSymbol.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -lockPadding),
            lockSymbol.topAnchor.constraint(equalTo: containerView.topAnchor, constant: lockPadding),
            lockSymbol.bottomAnchor.constraint(lessThanOrEqualTo: symbolLabel.topAnchor, constant: -2),
        ])
    }

    private func setupGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.delegate = self
        gestureRecognizer.numberOfTapsRequired = 0
        gestureRecognizer.minimumPressDuration = 0
        gestureRecognizer.addTarget(self, action: #selector(handleGesture))

        self.containerView.addGestureRecognizer(gestureRecognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("Not configured \(Self.self) for nib")
    }
}

// MARK: State Management

extension Card {

    func configure(with cardSymbol: CardSymbol?) {
        self.symbol = cardSymbol
        self.symbolLabel.text = cardSymbol?.label

        self.containerView.backgroundColor = cardSymbol?.color.withProminence(.secondary) ?? .white.withProminence(.secondary)

        animateLocked()
    }

    func isShowingLocked() -> Bool {
        self.lockSymbol.image == .Lock.fill.withRenderingMode(.alwaysTemplate)
    }

    func isLocked() -> Bool {
        self.symbol != nil
    }

    func animateLocked() {
        let image: UIImage = symbol != nil ? .Lock.fill : .Lock.Open.fill
        self.lockSymbol.setSymbolImage(image.withRenderingMode(.alwaysTemplate), contentTransition: .replace)
    }

    func animateLockShake() {
        let (midX, midY) = (lockSymbol.center.x, lockSymbol.center.y)

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: midX - 3, y: midY)
        animation.toValue = CGPoint(x: midX + 3, y: midY)
        animation.repeatCount = 2
        animation.duration = 0.1
        animation.isRemovedOnCompletion = true
        animation.autoreverses = true

        lockSymbol.layer.add(animation, forKey: "position")
    }
}

// MARK: Gesture Recognition

extension Card: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        if self.isShowingLocked() {
            animateLockShake()
        }
        return !self.isLocked()
    }

    @objc
    private func handleGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {

        // Animate button
        switch gestureRecognizer.state {
        case .began:
            print("Began")
            feedbackGenerator.impactOccurred()
            animateExpansion()
        case .changed:
            print("Changed")
        case .ended:

            let locationInView = gestureRecognizer.location(in: containerView)
            if containerView.bounds.contains(locationInView) {
                print("Ended in bounds")
                animateCompressionAndSelection()
            } else {
                print("Ended out of bounds")
                animateCompression()
            }

        case .cancelled:
            print("Cancelled")
        default:
            print("Default")
        }
    }

    private func animateCompression(additions: (() -> Void)? = nil) {
        UIView.animate(springDuration: 0.3, bounce: 0.7, options: .allowUserInteraction) {
            containerConstraints.changeTo(0)
            self.layoutIfNeeded()

            additions?()
        }
    }

    private func animateCompressionAndSelection() {
        animateCompression { [weak self] in
            guard let self else { return }
            self.delegate?.didSelectCard(self, at: self.tag)
        }
    }

    private func animateExpansion() {
        UIView.animate(springDuration: 0.3) {
            containerConstraints.changeTo(10)
            self.layoutIfNeeded()
        }
    }
}

#Preview("Card") {
    class MockDelegate: CardDelegate {
        func didSelectCard(_ card: Card, at index: Int) {
            card.configure(with: .haw)
            print("Selected!")
        }
    }

    let card = Card()
    card.configure(with: nil)

    let delegate = MockDelegate()
    PreviewStrongReference.add(delegate as Any)
    card.delegate = delegate

    NSLayoutConstraint.activate([
        card.heightAnchor.constraint(equalToConstant: 100),
        card.widthAnchor.constraint(equalTo: card.heightAnchor, multiplier: 1),
    ])

    return card
}


#Preview("Prominence Colors") {
    let color = UIColor.systemBrown

    let view1 = UIView()
    view1.backgroundColor = color.withProminence(.primary)

    let view2 = UIView()
    view2.backgroundColor = color.withProminence(.secondary)

    let view3 = UIView()
    view3.backgroundColor = color.withProminence(.tertiary)

    let view4 = UIView()
    view4.backgroundColor = color.withProminence(.quaternary)

    let stack = UIStackView(arrangedSubviews: [
        view1, view2, view3, view4
    ])

    stack.spacing = 10
    stack.axis = .vertical
    stack.distribution = .fillEqually

    return stack
}
