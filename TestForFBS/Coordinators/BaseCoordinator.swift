//
//  BaseCoordinator.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
 
class BaseCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    func start() {
        fatalError("Start method must be implemented")
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}
