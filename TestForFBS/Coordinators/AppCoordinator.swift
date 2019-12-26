//
//  AppCoordinator.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
  let window: UIWindow
  var navigationController: UINavigationController
  
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
  }
  
  func start() {
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    let repositoriesCoordinator = RepositoriesCoordinator(navigationController: navigationController)
    repositoriesCoordinator.start()
  }
}
