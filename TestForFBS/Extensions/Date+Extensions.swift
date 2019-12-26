//
//  Date+Extensions.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 26.12.2019.
//  Copyright © 2019 afldjakfj. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String = DateFormat.common.rawValue) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
