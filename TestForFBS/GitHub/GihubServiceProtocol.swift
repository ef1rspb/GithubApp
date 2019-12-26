//
//  GihubServiceProtocol.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import Foundation
import RxSwift

typealias ServerResponse = ([Repository]?, String?)

protocol GitHubServiceProtocol {
    func getRepositoryList(page: Int, topic: String) -> Observable<ServerResponse>
}
