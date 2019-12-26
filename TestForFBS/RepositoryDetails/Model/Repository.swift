//
//  Repository.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let fullName: String
    let name: String
    let owner: Owner
    let updatedAt: Date
    let stargazersCount: Int
    let description: String?
    let language: String?
    let htmlUrl: URL?
}
