//
//  Created by Pablo Balduz on 04/04/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit

class StretchyHeaderViewController: UIViewController, UIScrollViewDelegate {
    
    let headerImageView = UIImageView()
    let contentView = UIView()
    var contentViewTopOffset: CGFloat = 0 {
        didSet {
            contentViewTopConstraint.constant = -abs(contentViewTopOffset)
        }
    }
    
    private let scrollView = UIScrollView()
    private let contentBackingView = UIView()
    private let imageViewContainer = UIView()
    
    private let blurEffectView = UIVisualEffectView(effect: nil)
    private var animator: UIViewPropertyAnimator!
    
    private var headerImageViewTopConstraint: NSLayoutConstraint!
    private var headerImageViewBottomConstraint: NSLayoutConstraint!
    private var headerImageViewHeightConstraint: NSLayoutConstraint!
    private var contentViewTopConstraint: NSLayoutConstraint!
    private var contentViewBottomConstraint: NSLayoutConstraint!
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        let contentViewBounds = contentView.convert(contentView.bounds, to: nil)
        return contentViewBounds.minY < view.safeAreaInsets.top
    }
        
    override func loadView() {
        super.loadView()
        
        enableAutolayout()
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageViewContainer)
        scrollView.addSubview(headerImageView)
        scrollView.addSubview(contentBackingView)
        scrollView.addSubview(contentView)
        headerImageView.addSubview(blurEffectView)
        
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        let imageViewContainerConstraints = [
            imageViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewContainer.heightAnchor.constraint(equalTo: view.widthAnchor)
        ]
        let contentBackingViewConstraints = [
            contentBackingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentBackingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentBackingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentBackingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        setupContentViewConstraints()
        let contentViewConstraints = [
            contentViewTopConstraint!,
            contentViewBottomConstraint!,
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        setupHeaderImageViewConstraints()
        let headerImageViewConstraints = [
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImageViewTopConstraint!,
            headerImageViewBottomConstraint!,
            headerImageViewHeightConstraint!
        ]
        let blurEffectViewConstraints = [
            blurEffectView.topAnchor.constraint(equalTo: headerImageView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: headerImageView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: headerImageView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(scrollViewConstraints +
                                    imageViewContainerConstraints +
                                    headerImageViewConstraints +
                                    contentBackingViewConstraints +
                                    contentViewConstraints +
                                    blurEffectViewConstraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlurEffect()
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
                
        contentBackingView.backgroundColor = contentView.backgroundColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animator.stopAnimation(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        contentBackingView.backgroundColor = contentView.backgroundColor
        contentBackingView.layer.cornerRadius = contentView.layer.cornerRadius
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.2) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        let contentOffset = scrollView.contentOffset.y
        guard contentOffset < 0 else {
            animator.fractionComplete = 0
            return
        }
        animator.fractionComplete = abs(contentOffset) / 100
    }
    
    private func enableAutolayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentBackingView.translatesAutoresizingMaskIntoConstraints = false
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupHeaderImageViewConstraints() {
        headerImageViewHeightConstraint = headerImageView.heightAnchor.constraint(greaterThanOrEqualTo: imageViewContainer.heightAnchor)
        headerImageViewTopConstraint = headerImageView.topAnchor.constraint(equalTo: view.topAnchor)
        headerImageViewBottomConstraint = headerImageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor)
        headerImageViewTopConstraint.priority = .required
        headerImageViewBottomConstraint.priority = .defaultHigh
        headerImageViewHeightConstraint.priority = .required
    }
    
    private func setupContentViewConstraints() {
        contentViewTopConstraint = contentView.topAnchor.constraint(equalTo: imageViewContainer.bottomAnchor)
        contentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        contentViewBottomConstraint.priority = .required
    }
    
    private func setupBlurEffect() {
        animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: { [weak self] in
            let blurEffect = UIBlurEffect(style: .light)
            self?.blurEffectView.effect = blurEffect
        })
    }
}
