//
//  RepositoryDetailsViewController.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift

class RepositoryDetailsViewController: UIViewController, Storyboarded {

  // хардкодить ширину лэйбла "Thanks to" или кнопки "See Author Button" - это зло)
  // и констрэинты со точностью до сотых - это странно
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var authorLogin: UILabel!
    @IBOutlet weak var seeAuthorButton: UIButton!
    @IBOutlet weak var repositoryTitle: UILabel!
    @IBOutlet weak var stargazersCount: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var seeRepositoryButton: UIButton!
    @IBOutlet weak var updated: UILabel!
    
    var viewModel: RepositoryDetailsViewModel!
  // зачем var, если это let?
    var disposeBag = DisposeBag()
  // отделяем новой строкой
    override func viewDidLoad() {
        super.viewDidLoad()

      // self можно опустить
        self.setLargeTitleDisplayMode(.never)
        avatar.setRounded()
        
        viewModel.repository.subscribe(onNext: { [weak self] repository in
            self?.setUpViews(repository: repository)
        }).disposed(by: disposeBag)
        
        seeRepositoryButton.rx
            .controlEvent(.touchUpInside)
            .withLatestFrom(viewModel.repository)
            .subscribe(onNext: { [weak self] repository in
                if let url = repository.htmlUrl {
                    self?.openInSafari(url: url)
                }
            }).disposed(by: disposeBag)
        
        seeAuthorButton.rx
            .controlEvent(.touchUpInside)
            .withLatestFrom(viewModel.repository)
            .subscribe(onNext: { [weak self]  repository in
                self?.openInSafari(url: repository.owner.htmlUrl)
            }).disposed(by: disposeBag)
        
        viewModel
            .avatarImage
            .subscribe(onNext: { [weak self] image in
                DispatchQueue.main.async {
                    self?.avatar.image = image
                }
            }).disposed(by: disposeBag)
        
    }
    
    func setUpViews(repository: Repository) {
      // self можно опустить
        self.repositoryTitle.text = repository.name
        self.stargazersCount.text = String(repository.stargazersCount)
        self.descriptionTextView.text = repository.description
        self.authorLogin.text = repository.owner.login
        self.updated.text = repository.updatedAt.toString()
    }
    
    func openInSafari(url: URL) {
      // почему VC управляет цепочкой экранов, если в проекте есть координаторы?
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
    
}
