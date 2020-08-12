//
//  Created by Pablo Balduz on 12/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit
import MarvelHeroesKit

class HeroesCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private var window: UIWindow?
    private let rootViewController = UINavigationController()
    
    init(window: UIWindow?) {
        self.window = window
        window?.rootViewController = rootViewController
    }
    
    func start() {
        showHeroesList()
    }
    
    func showHeroDetail(id: Int, transitioningDelegate: UIViewControllerTransitioningDelegate) {
        let vm = HeroDetailViewModel(heroID: id, service: MarvelAPIClient())
        let vc = HeroDetailViewController(viewModel: vm)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transitioningDelegate
        rootViewController.viewControllers.last?.present(vc, animated: true, completion: nil)
    }
        
    // MARK: - Private
    
    private func showHeroesList() {
        let vm = HeroesListViewModel(service: MarvelAPIClient())
        let vc = HeroesListViewController(viewModel: vm)
        vc.coordinator = self
        rootViewController.pushViewController(vc, animated: false)
    }
    
}

