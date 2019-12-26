//
//  APIMessage.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import Foundation

enum APIMessage: String {
    case limitExceeded = "API rate limit exceeded"
    case maximumResultsExceeded = "search results are available"
}
