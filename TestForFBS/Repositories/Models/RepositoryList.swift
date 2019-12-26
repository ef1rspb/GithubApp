//
//  RepositoryList.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 afldjakfj. All rights reserved.
//

import Foundation

struct RepositoryList: Decodable {
    let items: [Repository]?
    let message: String?
}
