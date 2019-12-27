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

// когда приложение будет расширяться и, допустим, потребуется локализация, то этот код уже не будет работать
// одно из решений: отдельное свойство, которое отвечает за представление сообщения во вьюшке
//extension APIMessage {
//
//  var description: String {
//    switch self {
//    case .limitExceeded:
//      return "API rate limit exceeded" // или NSLocalizedString("API rate limit exceeded", comment: "")
//    case .maximumResultsExceeded:
//      return "search results are available"
//    }
//  }
//}
