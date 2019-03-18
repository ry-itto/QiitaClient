//
//  TrendsViewController.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/14.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TrendsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.cellIdentifier)
            tableView.estimatedRowHeight = 92
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    lazy var viewModel: TrendViewModel = {
        let modelSelected = tableView.rx.modelSelected(Trend.TrendArticle.self).asObservable()
        return TrendViewModel(modelSelected: modelSelected)
    }()
    
    static func instantiateWithTabBarItem() -> UINavigationController {
        let viewController = UINavigationController(rootViewController: TrendsViewController())
        viewController.title = "トレンド"
        viewController.tabBarItem.image = UIImage(named: "rising")
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoad.onNext(())
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
        viewModel.articles
            .bind(to: tableView.rx.items(cellIdentifier: QiitaArticleCell.cellIdentifier, cellType: QiitaArticleCell.self)) { row, article, cell in
                cell.configure(model: article)
            }.disposed(by: disposeBag)
        
        viewModel.showWebView
            .bind(to: Binder(self) { me, url in
                me.navigationController?.pushViewController(WebViewController(url: url), animated: true)
            }).disposed(by: disposeBag)
    }
}
