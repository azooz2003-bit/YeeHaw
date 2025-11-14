//
//  GameInfoView.swift
//  YeeHaw
//
//  Created by Abdulaziz Albahar on 11/13/25.
//

import UIKit

protocol GameInfoViewDelegate: AnyObject {
    func timerDidFinish()
}

class GameInfoView: UIView {
    private let dateFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    private var timer: Timer?
    private(set) var timeRemainingInSeconds: Int = 60 {
        didSet {
            // TODO: optimize, avoid recreation of attr string each time
            let asInterval = TimeInterval(timeRemainingInSeconds)
            let attrString = NSMutableAttributedString(attachment: .init(image: .Clock.fill))

            guard let timerStr = dateFormatter.string(from: asInterval) else {
                return
            }

            attrString.append(.init(string: " \(timerStr)"))
            timerLabel.attributedText = attrString
        }
    }

    private var timerLabel: UILabel!

    weak var delegate: GameInfoViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupTimerLabel()
        setupActiveSymbolView()
    }

    deinit {
        timer?.invalidate()
    }

    private func setupTimerLabel() {
        timerLabel = UILabel()
        timerLabel.textColor = .white
        timerLabel.font = .systemFont(ofSize: 14, weight: .medium)
        timerLabel.numberOfLines = 1

        timeRemainingInSeconds = 60

        timerLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(timerLabel)

        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: topAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func setupActiveSymbolView() {

    }

    func startTimer(forDuration duration: TimeInterval) {
        timer?.invalidate()
        timeRemainingInSeconds = 60 // 1 min

        timer = Timer(timeInterval: 1.0, repeats: true) { timer in
            self.timeRemainingInSeconds -= 1
            guard self.timeRemainingInSeconds > 0 else {
                timer.invalidate()
                self.delegate?.timerDidFinish()
                return
            }
        }
    }

    func setActiveSymbol(_ symbol: CardSymbol) {

    }
}
