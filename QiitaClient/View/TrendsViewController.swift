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

class TrendsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.cellIdentifier)
            tableView.estimatedRowHeight = 92
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    let viewModel: TrendViewModel = TrendViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoad.onNext(())
    }
    
    fileprivate func bindViewModel() {
        viewModel.articles
            .bind(to: tableView.rx.items(cellIdentifier: QiitaArticleCell.cellIdentifier, cellType: QiitaArticleCell.self)) { row, article, cell in
                cell.configure(model: article)
        }.disposed(by: disposeBag)
    }
}
