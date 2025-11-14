//
//  SequenceBoxCell.swift
//  YeeHaw
//
//  Created by Abdulaziz Albahar on 11/12/25.
//

import UIKit

class SequenceBoxCell: UICollectionViewCell {
    static let reuseId = "SequenceBoxCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        contentView.addSubview(label)

        label.pinToEdges(of: contentView)
    }

    func configure(_ text: String, isCompleted: Bool) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)

        if isCompleted {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributedString.length))
        }

        label.attributedText = attributedString
        
    }
}
