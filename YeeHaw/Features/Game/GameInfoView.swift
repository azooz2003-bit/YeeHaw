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
    private(set) var timeRemainingInSeconds: TimeInterval = 60 {
        didSet {
            // TODO: optimize, avoid recreation of attr string each time
            let attrString = NSMutableAttributedString(attachment: .init(image: .Alarm.fill))

            guard let timerStr = dateFormatter.string(from: timeRemainingInSeconds) else {
                return
            }

            attrString.append(.init(string: " \(timerStr)"))
            timerLabel.attributedText = attrString
        }
    }
    private var timerLabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.textColor = .white
        timerLabel.font = .systemFont(ofSize: 14, weight: .medium)
        timerLabel.numberOfLines = 1
        return timerLabel
    }()

    private var activeSymbolView: UIView = {
        let view = UIView()
        view.cornerConfiguration = .capsule()
        view.backgroundColor = .gray.withProminence(.secondary)

        return view
    }()
    private lazy var activeSymbolLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    private var activeSymbol: CardSymbol? {
        didSet {
            activeSymbolLabel.text = activeSymbol?.rawValue ?? "???"
            activeSymbolView.backgroundColor = activeSymbol?.color.withProminence(.secondary)
        }
    }

    // MARK: Public
    var placeholderTime: TimeInterval! {
        didSet {
            if timerLabel.text == nil {
                timeRemainingInSeconds = placeholderTime
            }
        }
    }
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
        self.placeholderTime = 60
        setupTimerLabel()
        setupActiveSymbolView()
    }

    deinit {
        timer?.invalidate()
    }

    private func setupTimerLabel() {
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
        addSubview(activeSymbolView)
        activeSymbolView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activeSymbolView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 8),
            activeSymbolView.leadingAnchor.constraint(equalTo: leadingAnchor),
            activeSymbolView.bottomAnchor.constraint(equalTo: bottomAnchor),
            activeSymbolView.heightAnchor.constraint(equalToConstant: 50),
            activeSymbolView.widthAnchor.constraint(equalTo: activeSymbolView.heightAnchor)
        ])

        activeSymbolView.addSubview(activeSymbolLabel)

        activeSymbolLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activeSymbolLabel.leadingAnchor.constraint(equalTo: activeSymbolView.leadingAnchor, constant: 6),
            activeSymbolLabel.trailingAnchor.constraint(equalTo: activeSymbolView.trailingAnchor, constant: -6),
            activeSymbolLabel.bottomAnchor.constraint(equalTo: activeSymbolView.bottomAnchor, constant: -6),
            activeSymbolLabel.topAnchor.constraint(equalTo: activeSymbolView.topAnchor, constant: 6)
        ])
    }

    func startTimer(forSeconds duration: TimeInterval) {
        timer?.invalidate()
        timeRemainingInSeconds = duration // 1 min

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.timeRemainingInSeconds -= 1
            if self.timeRemainingInSeconds <= 0 {
                timer.invalidate()
                self.delegate?.timerDidFinish()
                return
            }
        }
    }

    func setActiveSymbol(_ symbol: CardSymbol) {
        activeSymbol = symbol
    }
}

#Preview {
    let view = GameInfoView()
    view.setActiveSymbol(.haw)
    view.startTimer(forSeconds: 60)
    return view
}
