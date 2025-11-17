//
//  TransitionCoordinator.swift
//  YeeHaw
//
//  Created by Abdulaziz Albahar on 11/15/25.
//

import UIKit

class TransitionCoordinator: NSObject {
    enum Screen: String {
        case home = "HomeViewController"
        case game = "GameViewController"
    }

    private func duration(from fromScreen: Screen, to toScreen: Screen) -> TimeInterval {
        switch (fromScreen, toScreen) {
        // TODO: remove default & implement for all screens
        default: 0.8
        }
    }

    private func animateTransition(from presentingVC: UIViewController, to destinationVC: UIViewController, using context: UIViewControllerContextTransitioning) {
        guard
            let fromScreen = Screen(rawValue: presentingVC.rawType),
            let toScreen = Screen(rawValue: destinationVC.rawType)
        else {
            fatalError("Unexpected view controllers for transition.")
        }

        switch (fromScreen, toScreen) {
        case (.home, .game):
            guard let homeVC = presentingVC as? HomeViewController, let gameVC = destinationVC as? GameViewController else {
                fatalError("Received VCs for (\(fromScreen), \(toScreen)) that don't match expected view controllers.")
            }
            animateHomeToGame(homeVC, gameVC, using: context)
        default:
            break
        }
    }

    private func animateHomeToGame(_ homeVC: HomeViewController, _ gameVC: GameViewController, using context: UIViewControllerContextTransitioning) {

        let container = context.containerView

        container.addSubview(gameVC.view)
        gameVC.view.frame = homeVC.view.frame
        container.layoutIfNeeded() // to get latest frames (`gameVC.gridVC` in particular)

        guard context.isAnimated else {
            context.completeTransition(true)
            return
        }

        let gridFinalFrame = gameVC.gridVC.view.frame
        gameVC.gridVC.view.frame = homeVC.gridVC.view.frame
        homeVC.gridVC.view.isHidden = true

        gameVC.view.backgroundColor = .clear

        homeVC.bottomPanelVC.animateOut()

        gameVC.gameInfoView.transform = CGAffineTransform(translationX: -80, y: 0)
        UIView.animate(springDuration: 0.6, bounce: 0.4) {
            gameVC.gameInfoView.transform = .identity
        }

        UIView.animate(withDuration: 0.8) {
            gameVC.gridVC.view.frame = gridFinalFrame
            gameVC.view.layoutIfNeeded()
        }

        gameVC.sequenceBox.transform = CGAffineTransform(scaleX: 0, y: 0) // => .identity
        UIView.animate(springDuration: 0.6, bounce: 0.4) {
            gameVC.sequenceBox.transform = .identity
        } completion: { _ in
            // Undo all changes post-animation
            gameVC.view.backgroundColor = .systemBrown
            homeVC.gridVC.view.isHidden = false
            homeVC.bottomPanelVC.undoAnimation()

            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}

extension TransitionCoordinator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        guard
            let fromVC = transitionContext?.viewController(forKey: .from),
            let toVC = transitionContext?.viewController(forKey: .to),
            let fromScreen = Screen(rawValue: fromVC.rawType),
            let toScreen = Screen(rawValue: toVC.rawType)
        else {
            return 0.0
        }

        return duration(from: fromScreen, to: toScreen)
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }

        animateTransition(from: fromVC, to: toVC, using: transitionContext)
    }
}

extension TransitionCoordinator: UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return self
    }
}

extension UIViewController {
    fileprivate var rawType: String { String(describing: Self.self) }
}
