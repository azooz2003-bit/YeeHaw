//
//  CardCell.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/2/25.
//

import UIKit

class CardCell: UICollectionViewCell {
    static let identifier = String(describing: CardCell.self)

    let card = Card()

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        card.pinToEdges(of: contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("Not configured \(Self.self) for nib")
    }

    func configure(with cardSymbol: CardSymbol?) {
        card.configure(with: cardSymbol)
    }

    func isLocked() -> Bool {
        card.isShowingLocked()
    }

    func animateLocked() {
        card.animateLocked()
    }
}
