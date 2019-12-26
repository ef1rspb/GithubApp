//
//  AppDelegate.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var navigationController = UINavigationController()
    static let instance: AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate //swiftlint:disable:this force_cast
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let appCoordinator = AppCoordinator(window: window, navigationController: navigationController)
        
        self.window = window
        self.appCoordinator = appCoordinator
        
        appCoordinator.start()
        return true
    }
}
