//
//  Owner.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import Foundation

struct Owner: Decodable {
    let login: String
    let avatarUrl: URL
    let htmlUrl: URL
}
