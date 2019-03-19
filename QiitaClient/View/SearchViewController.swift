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
            searchBar.placeholder = "Search"
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.cellIdentifier)
            tableView.rowHeight = QiitaArticleCell.rowHeight
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.tableFooterView = UIView()
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    fileprivate func bindViewModel() {
        
        viewModel.searchResult
            .bind(to: tableView.rx.items(cellIdentifier: QiitaArticleCell.cellIdentifier, cellType: QiitaArticleCell.self)) { row, article, cell in
                cell.configure(model: article)
            }.disposed(by: disposeBag)
    }
}

extension SearchViewController: UISearchBarDelegate {}
