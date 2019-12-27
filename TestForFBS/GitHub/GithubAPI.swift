//
//  GithubAPI.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import Foundation
import Moya

// GitHubAPITarget точнее описывает назначение сущности
enum GitHubAPI {
    case getRepositoryList(page: Int, topic: String)
}

extension GitHubAPI: TargetType {

    var baseURL: URL {
        var components = URLComponents()
         components.scheme = "https"
         components.host = "api.github.com"
        return components.url!
    }
    
    var path: String {
        switch self {
        case .getRepositoryList: return "/search/repositories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRepositoryList: return .get
        }
    }
    
    var headers: [String: String]? {
        return .none
    }
    
    var sampleData: Data {
        switch self {
        case .getRepositoryList:
            return APIMock.repositoryList!
        }
    }
   
    var task: Task {
        switch self {
        case let .getRepositoryList(page, topic):
            let parameters: [String: Any] = [
                "q": topic,
                "sort": "stars",
                "page": page
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
}
