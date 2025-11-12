//
//  CardsCollectionViewController.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/4/25.
//

import UIKit

//class CardsCollectionViewController: UIViewController, CardsViewControlling {
//    var collectionView: UICollectionView!
//
//    var viewModel: CardsViewModel
//
//    required init(cardsViewModel: CardsViewModel) {
//        self.viewModel = cardsViewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .clear
//
//        self.configureCollectionView()
//    }
//
//    private func configureCollectionView() {
//        let collectionLayout = CardsCollectionLayout()
//        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.isScrollEnabled = false
//        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
//
//        collectionView.backgroundColor = .clear
//
//        self.view.addSubview(collectionView)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
//    }
//}
//
//extension CardsCollectionViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        let selectionIsAccepted = viewModel.selectCard(at: indexPath)
//        if selectionIsAccepted {
//            collectionView.reloadItems(at: [indexPath])
//            animateLockSymbol(at: indexPath)
//        } else {
//            // TODO: show buzzing, scaling size up, lock animation if rejected
//        }
//
//    }
//
//    private func animateLockSymbol(at indexPath: IndexPath) {
//        DispatchQueue.main.async {
//            guard
//                let cell = self.collectionView.cellForItem(at: indexPath) as? CardCell,
//                !cell.isLocked()
//            else {
//                return
//            }
//
//            // Set and animate lock image only if lock image isn't active
//
//            cell.animateLocked()
//        }
//    }
//}
//
//extension CardsCollectionViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
//            fatalError("Invalid state, dequeued cell was not of type (\(CardCell.self))")
//        }
//
//        let numCols = viewModel.state[0].count
//        let (row, col) = indexPath.twoDimIndex(numberOfColumns: numCols)
//        cell.configure(with: viewModel.state[row][col])
//
//        return cell
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let numRows = viewModel.state.count
//        let numCols = viewModel.state[0].count
//        return numRows * numCols
//    }
//}
//
//
//#Preview {
//    CardsCollectionViewController(cardsViewModel: CardsViewModel())
//}
