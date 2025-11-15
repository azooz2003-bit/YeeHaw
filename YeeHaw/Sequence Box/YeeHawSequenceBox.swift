//
//  YeeHawSequenceBox.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 11/1/25.
//

import UIKit
import Combine

class YeeHawSequenceBox: UIView {

    private lazy var container: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.cornerConfiguration = .corners(radius: 10)
        view.clipsToBounds = true
        let effect = UIGlassEffect(style: .regular)
        effect.isInteractive = true
        effect.tintColor = .brown
        view.effect = effect
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var viewModeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.addAction(UIAction { [weak self] _ in
            self?.handleViewModeToggle()
        }, for: .touchUpInside)
        button.contentHorizontalAlignment = .center

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.itemSize = CGSize(width: 100, height: 15)
        flowLayout.sectionInset = .init(top: 10, left: 15, bottom: 10, right: 15)

        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.register(SequenceBoxCell.self, forCellWithReuseIdentifier: SequenceBoxCell.reuseId)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()

    private lazy var currentSequenceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        return label
    }()

    var displayAll: Bool = false {
        didSet {
            if displayAll {
                viewModeButton.setImage(.customTextformatSizeLargerCircleFill, for: .normal)
            } else {
                viewModeButton.setImage(.Square.Grid.TwoByTwo.fill, for: .normal)
            }
        }
    }

    var gameVM: GameViewModel
    var cancellables: Set<AnyCancellable> = []

    init(gameVM: GameViewModel, frame: CGRect = .zero) {
        self.gameVM = gameVM
        super.init(frame: frame)

        setupContainer()
        setupViewModeButton()
        handleViewModeToggle()

        gameVM.sequences
            .receive(on: DispatchQueue.main)
            .sink { _ in self.reload() }
            .store(in: &cancellables)

        gameVM.currentSequence
            .receive(on: DispatchQueue.main)
            .sink {
                self.currentSequenceLabel.text = $0?.label()
            }
            .store(in: &cancellables)
    }

    private func setupContainer() {
        self.addSubview(container)

        container.pinToEdges(of: self)
    }

    private func setupViewModeButton() {
        container.contentView.addSubview(viewModeButton)

        displayAll = true

        NSLayoutConstraint.activate([
            viewModeButton.topAnchor.constraint(equalTo: container.topAnchor),
            viewModeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            // Setting larger height to allow for larger tap radius
            viewModeButton.widthAnchor.constraint(equalToConstant: 40),
            viewModeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupCollectionView() {
        container.contentView.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: container.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: viewModeButton.leadingAnchor)
        ])
    }

    private func setupSequenceLabel() {
        container.contentView.addSubview(self.currentSequenceLabel)

        currentSequenceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentSequenceLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            currentSequenceLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            currentSequenceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor),
            currentSequenceLabel.trailingAnchor.constraint(lessThanOrEqualTo: viewModeButton.trailingAnchor),
            currentSequenceLabel.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor),
            currentSequenceLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor)
        ])
    }

    private func handleViewModeToggle() {
        displayAll.toggle()

        if displayAll {
            collectionView.alpha = 0
            collectionView.transform = CGAffineTransform(translationX: 0, y: -10)
            setupCollectionView()
            UIView.animate {
                self.collectionView.alpha = 1
                self.collectionView.transform = .identity
                self.currentSequenceLabel.alpha = 0
            } completion: { done in
                guard done, self.displayAll else { return }
                self.currentSequenceLabel.removeFromSuperview()
            }
        } else {
            currentSequenceLabel.alpha = 0
            currentSequenceLabel.transform = CGAffineTransform(translationX: 0, y: -10)
            setupSequenceLabel()
            UIView.animate {
                self.currentSequenceLabel.alpha = 1
                self.currentSequenceLabel.transform = .identity
                self.collectionView.alpha = 0
            } completion: { done in
                guard done, !self.displayAll else { return }
                self.collectionView.removeFromSuperview()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public

    func reload() {
        collectionView.reloadData()
    }
}

extension YeeHawSequenceBox: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SequenceBoxCell.reuseId, for: indexPath) as! SequenceBoxCell

        let sequence = gameVM.sequences.value[indexPath.item]
        let sequenceText = sequence.label()

        cell.configure(sequenceText, isCompleted: sequence.completionStatus.isComplete)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gameVM.sequences.value.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

#Preview {
    let view = UIView()
    view.backgroundColor = .black
    view.frame = .init(x: 0, y: 0, width: 500, height: 500)

    let vm =  GameViewModel()
    vm.sequences.send([
        .init(symbols: (.yee, .haw, .yee), color: .red, completionStatus: .incomplete)
    ])

    let box = YeeHawSequenceBox(gameVM: vm, frame: .zero)
    box.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(box)

    NSLayoutConstraint.activate([
        box.widthAnchor.constraint(equalToConstant: 400),
        box.heightAnchor.constraint(equalToConstant: 100),
        box.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        box.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])


    return view
}
