//
//  RepositoriesViewController.swift
//  TestForFBS
//
//  Created by Mikhail Kuzmin on 25.12.2019.
//  Copyright © 2019 Mikhail Kuzmin. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class RepositoriesViewController: UIViewController, UITableViewDelegate, Storyboarded {
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    var viewModel: RepositoriesViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.setLargeTitleDisplayMode(.never)
        configureSearchController()
        
        // MARK: Tableview configuration
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: RepositoryCell.id)
        tableView.separatorColor = UIColor.gray
        tableView.keyboardDismissMode = .onDrag
        
        setupTableViewBindings()
        setupSearchbarBindings()
        setupViewModelBindings()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = false
        searchBar.isTranslucent = false
        searchBar.placeholder = "Search on GitHub"
        tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = true
    }
    
    func setupViewModelBindings() {
        viewModel.isLoading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.activityindicator.startAnimating()
                    self?.activityindicator.isHidden = false
                } else {
                    self?.activityindicator.stopAnimating()
                    self?.activityindicator.isHidden = true
                }
            }).disposed(by: disposeBag)
        
        viewModel.onFetchFailed.subscribe(onNext: { error in
            self.displayMessage("Something went wrong", error: true)
        }).disposed(by: disposeBag)
        
        viewModel.onMessageFromAPI.subscribe(onNext: { message in
            switch message {
            case .limitExceeded:
                self.displayMessage("Requests limit exceeded\nTry again later.")
            case .maximumResultsExceeded:
                self.displayMessage("The maximum of results per search reached")
            }
            }).disposed(by: disposeBag)
    }
    
    func setupTableViewBindings() {
        
        viewModel.repositories
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                if list.isEmpty {
                    if let emptyView = Bundle.main.loadNibNamed("RepositoriesEmptyView", owner: nil, options: nil)?[0] as? UIView {
                        self?.tableView.backgroundView = emptyView
                        self?.tableView.isScrollEnabled = false
                    }
                } else {
                    self?.tableView.backgroundView = UIView()
                    self?.tableView.isScrollEnabled = true
                }
            }).disposed(by: disposeBag)
        
        viewModel.repositories
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx
                        .items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)) { _, element, cell in
                            cell.titleLabel.text = element.fullName
                            cell.descriptionLabel.text = element.description
                            cell.stargazersLabel.text = String(element.stargazersCount)
                            if let language = element.language {
                                cell.languageLabel.text = language
                            } else {
                                cell.languageLabel.isHidden = true
                            }
                        }.disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .debounce(RxTimeInterval(0.05), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] offset in
                if let `self` = self {
                    if offset.y + self.tableView.frame.size.height + 25.0 > self.tableView.contentSize.height {
                        self.viewModel.onPaginationFetchTriggered.onNext(())
                    }
                }
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Repository.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.coordinator.showRepositoryDetailsViewController(repository: $0)
            }).disposed(by: disposeBag)
    }
    
    func setupSearchbarBindings() {
        searchBar.rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .debounce(RxTimeInterval(1.0), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.onSearchFetchTriggered.onNext(text)
            }).disposed(by: disposeBag)
        
        searchBar.rx
            .searchButtonClicked
            .subscribe(onNext: { [weak self] in
                if let searchBar = self?.searchBar {
                    if searchBar.isFirstResponder {
                        self?.searchBar.resignFirstResponder()
                    }
                }

            }).disposed(by: disposeBag)
    }
    
    func displayMessage(_ message: String, error: Bool = false) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.dismiss(withDelay: 2)
        if error {
            SVProgressHUD.showError(withStatus: message)
        } else {
            SVProgressHUD.showInfo(withStatus: message)
        }
    }
}
