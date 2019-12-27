//
//  GitHubService.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class GitHubService: GitHubServiceProtocol {
    
    init(provider: MoyaProvider<GitHubAPI>) {
        self.provider = provider
    }
    
    let provider: MoyaProvider<GitHubAPI>
    let disposeBag = DisposeBag()
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    func getRepositoryList(page: Int, topic: String) -> Observable<ServerResponse> {
        return Observable.create { [unowned self] observer in
            self.provider.rx
                .request(.getRepositoryList(page: page, topic: topic))
                .map(RepositoryList.self, using: self.decoder)
                .subscribe(onSuccess: { list in
                    let response = ServerResponse(list.items, list.message)
                    observer.onNext(response)
                    observer.onCompleted()
                }, onError: {
                    observer.onError($0)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
}
