//
//  Created by Pablo Balduz on 12/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit

enum TransitionKind {
    case presentation
    case dismissal

    var isPresenting: Bool {
        return self == .presentation
    }
}

protocol ImageTransitionAnimatorDelegate {
    var transitionImageView: UIImageView? { get }
}

final class ImageTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 1.5
    private let kind: TransitionKind
    private let presentingDelegate: ImageTransitionAnimatorDelegate
    private let presentedDelegate: ImageTransitionAnimatorDelegate
    
    init?(kind: TransitionKind, presentingDelegate: ImageTransitionAnimatorDelegate, presentedDelegate: ImageTransitionAnimatorDelegate) {
        self.kind = kind
        self.presentingDelegate = presentingDelegate
        self.presentedDelegate = presentedDelegate
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let isPresenting = kind.isPresenting
        
        let presentedViewController = isPresenting ? transitionContext.viewController(forKey: .to) : transitionContext.viewController(forKey: .from)
        let presentingViewController = isPresenting ? transitionContext.viewController(forKey: .from) : transitionContext.viewController(forKey: .to)
        guard let presentedView = presentedViewController?.view, let presentingView = presentingViewController?.view else {
            transitionContext.completeTransition(false)
            return
        }

        presentedView.alpha = 0
        containerView.addSubview(presentedView)
                
        guard let window = presentingViewController?.view.window ?? presentedViewController?.view.window,
            let presentedImageView = presentedDelegate.transitionImageView,
            let presentingImageView = presentingDelegate.transitionImageView else {
                transitionContext.completeTransition(true)
                return
        }
        guard let presentingImageViewSnapshot = presentingImageView.snapshotView(afterScreenUpdates: true),
            let presentedImageViewSnapshot = presentedImageView.snapshotView(afterScreenUpdates: true) else {
                transitionContext.completeTransition(true)
                return
        }
        let presentingImageViewRect = presentingImageView.convert(presentingImageView.bounds, to: window)
        let presentedImageViewRect = presentedImageView.convert(presentedImageView.bounds, to: window)
                
        let imageViewSnapshot: UIView
        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.frame)
        fadeView.backgroundColor = .white
        
        if isPresenting {
            imageViewSnapshot = presentingImageViewSnapshot
            imageViewSnapshot.frame = presentingImageViewRect
            backgroundView = UIView(frame: containerView.frame)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0
        } else {
            imageViewSnapshot = presentedImageViewSnapshot
            imageViewSnapshot.frame = presentedImageViewRect
            backgroundView = presentingView.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
        }

        [presentedView, backgroundView, imageViewSnapshot].forEach(containerView.addSubview)
        
        UIView.animate(withDuration: duration, animations: {
            imageViewSnapshot.frame = isPresenting ? presentedImageViewRect : presentingImageViewRect
            fadeView.alpha = isPresenting ? 1 : 0
        }) { _ in
            backgroundView.removeFromSuperview()
            imageViewSnapshot.removeFromSuperview()
            presentedView.alpha = 1
            transitionContext.completeTransition(true)
        }
    }
}
