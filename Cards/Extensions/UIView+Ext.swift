//
//  UIView+Ext.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/4/25.
//

import UIKit

extension UIView {
    func pinToEdges(of view: UIView, padding: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: padding),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: padding),
        ])
    }
}
