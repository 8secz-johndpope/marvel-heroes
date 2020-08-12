//
//  SceneDelegate.swift
//  MarvelHeroes
//
//  Created by Pablo Balduz on 06/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var coordinator: Coordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        defer { window?.makeKeyAndVisible() }
        window?.windowScene = scene
        
        guard !scene.isRunningTests else {
            window?.rootViewController = UIViewController()
            return
        }
        
        coordinator = HeroesCoordinator(window: window)
        coordinator.start()
    }
}
