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

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    private let disposeBag = DisposeBag()
    lazy var viewModel: SearchViewModel = {
        let input = SearchViewModel.Input(
            search: self.searchBar.rx.text.orEmpty.asObservable(),
            selectedTags: self._selectedTags.asObservable()
        )
        return SearchViewModel(input: input)
    }()
    
    private let _selectedTags = PublishRelay<[String]>()
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = "Search"
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.cellIdentifier)
            tableView.estimatedRowHeight = QiitaArticleCell.rowHeight
            tableView.rowHeight = UITableView.automaticDimension
            tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var filterButton: UIButton!
    
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
        if UserDefaults.standard.string(forKey: "qiita_access_token")?.isEmpty ?? true {
            present(LoginViewController.shared, animated: true, completion: nil)
        } else {
            print(UserDefaults.standard.string(forKey: "qiita_access_token"))
        }
    }
    
    fileprivate func bindViewModel() {
        
        let modalEvent = ModalEventWrapper.instance

        viewModel.searchResult
            .bind(to: tableView.rx.items(cellIdentifier: QiitaArticleCell.cellIdentifier, cellType: QiitaArticleCell.self)) { row, article, cell in
                cell.configure(model: article)
            }.disposed(by: disposeBag)
        
        tableView.rx.didScroll.asObservable()
            .debounce(0.2, scheduler: MainScheduler.instance)
            .bind(to: Binder(self) { me, _ in
                if me.tableView.isNearBottomEdge(edgeOffset: 500) {
                    me.viewModel.addArticles.onNext(me.searchBar.text!)
                }
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(QiitaAPI.Article.self)
            .subscribe(onNext: { [weak self] article in
                self?.navigationController?.pushViewController(WebViewController(url: article.url), animated: true)
            }).disposed(by: disposeBag)
        
        filterButton.rx.tap.asObservable()
            .bind(to: Binder(self) { me, _ in
                
                let tagListVC = TagListViewController()
                /// skipを入れないと一回selectedTagsのsubscribeが走ってしまい, modelが空になってしまうためskip1回を入れている.
                tagListVC.selectedTags
                    .skip(1)
                    .concat(Observable.never())
                    .bind(to: me._selectedTags)
                    .disposed(by: tagListVC.disposeBag)
                
                me.present(tagListVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        modalEvent.tagModalClose
            .subscribe(onNext: { vc in
                vc.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        modalEvent.loginModalClose
            .subscribe(onNext: { vc in
                vc.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
}
