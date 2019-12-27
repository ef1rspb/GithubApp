//
//  UIImageView+Extensions.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import UIKit

extension UIImageView {
    func setRounded() {
      // self можно опустить
        self.layer.cornerRadius = (self.frame.width / 2) //а скобки зачем? //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}
