//
//  SerchViewController.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/16.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    lazy var viewModel = {
        return SearchViewModel(search: searchBar.rx.text.orEmpty.asObservable())
    }()
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = "Search Repositries..."
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    static func instantiateWithTabBarItem() -> UINavigationController {
        let viewController = UINavigationController(rootViewController: SearchViewController())
        viewController.title = "検索"
        viewController.tabBarItem.image = UIImage(named: "search")
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        print(QiitaSearchDataProvider().fetchArticles(query: "qiita"))
    }
    
    fileprivate func bindViewModel() {
        
        viewModel.searchResult
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, article, cell in
                cell.textLabel?.text = article.title
            }.disposed(by: disposeBag)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
}
