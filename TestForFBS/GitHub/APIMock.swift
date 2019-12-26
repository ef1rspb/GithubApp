//
//  APIMock.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import Foundation

struct APIMock {
   static let repositoryList = """
        {
            "items": [{
                "id": 60832029,
                "name": "repo",
                "full_name": "test/repo",
                "owner": {
                    "login": "test",
                    "avatar_url": "https://avatars2.githubusercontent.com/u/16550840?v=4",
                    "html_url": "https://github.com/LYM-mg"
                },
                "html_url": "https://github.com/LYM-mg/MGDYZB",
                "description": "Test Description",
                "url": "https://api.github.com/repos/LYM-mg/MGDYZB",
                "updated_at": "2015-08-06T00:00:01Z",
                "stargazers_count": 64,
                "language": "Swift"
            }]
        }
    """.data(using: .utf8)
}
