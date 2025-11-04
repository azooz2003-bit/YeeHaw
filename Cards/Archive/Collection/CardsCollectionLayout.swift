//
//  CardsCollectionLayout.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/2/25.
//

import UIKit

class CardsCollectionLayout: UICollectionViewCompositionalLayout {
    init() {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1/3.0), heightDimension: .fractionalHeight(1.0)),
            supplementaryItems: []
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3.0)), subitems: [item])
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)

        super.init(section: section)

        self.configuration.scrollDirection = .vertical
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
