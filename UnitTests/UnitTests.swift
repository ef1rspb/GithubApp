//
//  TestGitHubService.swift
//  TestForFBSTests
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import Moya

@testable import TestForFBS

// Mock

let mockError = NSError(domain: "test", code: 1)

class GithubServiceErrorMock: GitHubServiceProtocol {
    func getRepositoryList(page: Int, topic: String) -> Observable<ServerResponse> {
        return Observable.create { observable in
            observable.onError(mockError)
            return Disposables.create()
        }
    }
}

class TestGitHubService: XCTestCase {
    var service: GitHubServiceProtocol!
    var disposeBag: DisposeBag!
    var provider: MoyaProvider<GitHubAPI>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        provider = MoyaProvider<GitHubAPI>(stubClosure: MoyaProvider.immediatelyStub)
        service = GitHubService(provider: provider)
    }

    func testDecoding() throws {
        do {
             _ = try service.getRepositoryList(page: 1, topic: "test").toBlocking().first()
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
}

class TestRepositoriesViewModel: XCTestCase {
    var service: GitHubServiceProtocol!
    var disposeBag: DisposeBag!
    var provider: MoyaProvider<GitHubAPI>!
    var viewModel: RepositoriesViewModel!
    var coordinator: RepositoriesCoordinator!
    
    func mockRepositoryModel() -> [Repository]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = APIMock.repositoryList
        if let data = data {
            do {
                let mock = try decoder.decode(RepositoryList.self, from: data)
                return mock.items!
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    override func setUp() {
        disposeBag = DisposeBag()
        provider = MoyaProvider<GitHubAPI>(stubClosure: MoyaProvider.immediatelyStub)
        service = GitHubService(provider: provider)
        coordinator = RepositoriesCoordinator(navigationController: UINavigationController())
        viewModel = RepositoriesViewModel(coordinator: coordinator, service: service)
    }
    
    let mockErrorMessage = "Unable to retrive a mock data"
    
    // MARK: Fetching tests

    func testFetchingOnSearch() throws {
        guard let expected = mockRepositoryModel()?[0] else {
            XCTFail(mockErrorMessage)
            return
        }
        
        viewModel.onSearchFetchTriggered.on(.next("test"))
        
        let result = try viewModel.repositories.toBlocking().first()!
        
        XCTAssertEqual(expected.id, result[0].id)
    }
    
    func testFetchingOnPaging() throws {
        guard let expected = mockRepositoryModel()?[0] else {
            XCTFail(mockErrorMessage)
            return
        }

        viewModel.search.accept("test")
        viewModel.onPaginationFetchTriggered.on(.next(()))
        
        let result = try viewModel.repositories.toBlocking().first()!
        
        XCTAssertEqual(expected.id, result[0].id)
    }
}
