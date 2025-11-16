//
//  CardsRow.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/4/25.
//

import UIKit

class CardsRow: UIView {
    private var rowStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .horizontal

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init() {
        super.init(frame: .zero)

        self.addSubview(rowStackView)
        self.rowStackView.pinToEdges(of: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCards(_ cards: [Card]) {
        for view in cards {
            self.rowStackView.addArrangedSubview(view)
        }
    }
}

#Preview {
    let row = CardsRow()
    let cards = [
        Card(),
        Card(),
        Card()
    ]

    for (i, card) in cards.enumerated() {
        if i % 2 == 0 {
            card.configure(with: .haw)
        } else {
            card.configure(with: .yee)
        }
    }

    // TODO: set tags for cards
    row.addCards(cards)

    return row
}

#Preview {
    let row = CardsRow()
    row.heightAnchor.constraint(lessThanOrEqualToConstant: 80).isActive = true


    let cards = [
        Card(),
        Card(),
        Card(),
        Card()
    ]

    for (i, card) in cards.enumerated() {
        if i % 2 == 0 {
            card.configure(with: nil)
        } else {
            card.configure(with: .yee)
        }

        card.widthAnchor.constraint(equalTo: card.heightAnchor).isActive = true
    }

    row.addCards(cards)

    return row
}
