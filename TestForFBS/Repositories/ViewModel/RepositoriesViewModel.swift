//
//  RepositoryListViewModel.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 afldjakfj. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RepositoriesViewModel {
    
    var coordinator: RepositoriesCoordinator
  // прям все свойства должны быть internal?
    let service: GitHubServiceProtocol
    let disposeBag = DisposeBag()
    
    let repositories = BehaviorRelay<[Repository]>(value: [])
    let currentPage = BehaviorRelay<Int>(value: 1)
    let search = BehaviorRelay<String>(value: "")
    
    // MARK: Output
    let isLoading = BehaviorRelay<Bool>(value: false)
    let onFetchFailed = PublishSubject<Error>()
    let onMessageFromAPI = PublishSubject<APIMessage>()
    
    // MARK: Input
    let onPaginationFetchTriggered = PublishSubject<Void>()
    let onSearchFetchTriggered = PublishSubject<String>()
    
    // MARK: Fetching
    
    enum FetchContext {
        case replace
        case extend
    }
    
    func fetchRepositories(_ context: FetchContext) {
        guard isLoading.value != true else { return }
        isLoading.accept(true)
        service.getRepositoryList(page: currentPage.value, topic: search.value)
            .timeout(RxTimeInterval(10), scheduler: MainScheduler.instance)
          // на каждый вызов fetchRepositories создается новая подписка, ресурсы будут утекать.
          // можно добавить .asSingle()
          // но тебе повезло, что moyaProvider уже возвращает single, а обертка Observable ниче не решает
            .subscribe(onNext: { items, message in
                if let items = items {
                    switch context {
                    case .extend:
                        self.repositories.accept(self.repositories.value + items)
                    case .replace:
                        self.repositories.accept(items)
                    }
                } else if let message = message {
                    if message.contains(APIMessage.limitExceeded.rawValue) {
                        self.onMessageFromAPI.onNext(APIMessage.limitExceeded)
                    } else if message.contains("search results are available") {
                        return // а тогда смысл этой проверки? ниже все равно ничего нет
                    }
                }
            }, onError: { error in
                self.onFetchFailed.onNext((error)) // пара скобок лишняя
                self.isLoading.accept(false)
            }, onCompleted: {
                self.isLoading.accept(false)
            }).disposed(by: disposeBag)
    }
    
    init(coordinator: RepositoriesCoordinator, service: GitHubServiceProtocol) {
        self.coordinator = coordinator
        self.service = service
        
        // MARK: input actions binding
        
        onPaginationFetchTriggered
            .subscribe(onNext: { [unowned self] _ in
                guard !self.search.value.isEmpty else {
                    return
                }
                self.currentPage.accept(self.currentPage.value + 1)
                self.fetchRepositories(.extend)
            }).disposed(by: disposeBag)
        
        onSearchFetchTriggered
            .subscribe(onNext: { [unowned self] text in
                if text.isEmpty {
                    self.search.accept(text)
                    self.currentPage.accept(1)
                    self.repositories.accept([])
                } else {
                    self.search.accept(text)
                    self.currentPage.accept(1)
                    self.fetchRepositories(.replace)
                }
            }).disposed(by: disposeBag)
    }
}
