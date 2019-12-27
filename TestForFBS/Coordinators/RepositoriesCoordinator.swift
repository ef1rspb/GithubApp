//
//  AppCoordinator.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import UIKit
import Moya

class RepositoriesCoordinator: BaseCoordinator {

  // а смысл?
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
        
    override func start() {
        showRepositories()
    }
    
    func showRepositories() {
        let provider = MoyaProvider<GitHubAPI>()
        let viewController = RepositoriesViewController.instantiate()
        let githubService = GitHubService(provider: provider)
      // во вьюмодель прокидывается координатор, который вьюмодель никогда не дергает.
      // Может сразу назначить вьюконтроллеру координатор? а то что-то сложнаа
        viewController.viewModel = RepositoriesViewModel(coordinator: self, service: githubService)
      // self можно опустить
      // это то же самое, что и pushViewController?
      self.navigationController.setViewControllers([viewController], animated: true)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.title = "Repositories"
    }
    
    func showRepositoryDetailsViewController(repository: Repository) {
        let viewController = RepositoryDetailsViewController.instantiate()
        viewController.viewModel = RepositoryDetailsViewModel(repository: repository)
        self.navigationController.pushViewController(viewController, animated: true)
        navigationController.navigationItem.title = "Details"
    }
}
