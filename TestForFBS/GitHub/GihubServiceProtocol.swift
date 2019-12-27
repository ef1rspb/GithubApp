//
//  GihubServiceProtocol.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import Foundation
import RxSwift

// а если приложение будет чуть сложнее калькулятора, то как будем отличать один ServerResponse от другого?
typealias ServerResponse = ([Repository]?, String?)

// то что это протокол говорит само объявление
protocol GitHubServiceProtocol {
    func getRepositoryList(page: Int, topic: String) -> Observable<ServerResponse>
}
