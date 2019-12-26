//
//  Storyboarded.swift
//
//  Created by Someone on 04.12.2019.
//  Copyright © 2019 Someone. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let viewControllerSuffix = "ViewController"
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        
        guard className.hasSuffix(viewControllerSuffix) else {
            fatalError("Unable to instantiate a ViewController with name: \(fullName)")
        }
        
        let storyboardName = String(className.dropLast(viewControllerSuffix.count))
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        if let storyboard = storyboard
            .instantiateViewController(withIdentifier: className) as? Self {
            return storyboard
        } else {
            fatalError("Unable to instantiate a ViewController with name: \(fullName)")
        }
        
    }
}
