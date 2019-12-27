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
import SafariServices // зачем?

class RepositoryDetailsViewModel {
  // зачем это Observable? репа же никогда не обновляется
    var repository: Observable<Repository>
    var avatarImage = BehaviorRelay<UIImage>(value: UIImage(named: "user")!)
    
    let disposeBag = DisposeBag()

  // cвойство нигде не используется
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    init(repository: Repository) {
        self.repository = BehaviorSubject<Repository>(value: repository)
        setup()
    }
    
    func downloadAvatarImage(url: URL) {
        URLSession.shared.dataTask( with: url, completionHandler: { (data, _, _) -> Void in
            DispatchQueue.global(qos: .userInteractive).async {
                if let data = data {
                  // а если не получится сформировать UIImage из данных?
                  // BehaviorRelay: Unlike `BehaviorSubject` it can't terminate with error or completed.
                  // поэтому здесь оно и не завершится с ошибкой, а просто упадет) жескаа
                  // а вот как раз completed для загрузки изображения может и пригодиться в будущем,
                  // потому что загружать картинку надо только один раз
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
