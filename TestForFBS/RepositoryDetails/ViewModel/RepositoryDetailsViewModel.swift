//
//  RepositoryDetailsViewModel.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SafariServices

class RepositoryDetailsViewModel {
    var repository: Observable<Repository>
    var avatarImage = BehaviorRelay<UIImage>(value: UIImage(named: "user")!)
    
    let disposeBag = DisposeBag()
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    init(repository: Repository) {
        self.repository = BehaviorSubject<Repository>(value: repository)
        setup()
    }
    
    func downloadAvatarImage(url: URL) {
        URLSession.shared.dataTask( with: url, completionHandler: { (data, _, _) -> Void in
            DispatchQueue.global(qos: .userInteractive).async {
                if let data = data {
                    self.avatarImage.accept(UIImage(data: data)!)
                }
            }
        }).resume()
    }
    
    func setup() {
        repository.subscribe(onNext: { [weak self] repository in
            self?.downloadAvatarImage(url: repository.owner.avatarUrl)
        }).disposed(by: disposeBag)
    }
    
}
