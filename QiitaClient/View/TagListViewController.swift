//
//  TagListViewController.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/20.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TagListViewController: UIViewController {
    
    let modalEvent = ModalEventWrapper.instance
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "QiitaTagCell", bundle: nil), forCellReuseIdentifier: QiitaTagCell.cellIdentifier)
            tableView.rowHeight = QiitaTagCell.rowHeight
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.allowsMultipleSelection = true
        }
    }
    
    private lazy var viewModel: TagListViewModel = {
        let input = TagListViewModel.Input(
            modelSelected: tableView.rx.modelSelected(QiitaAPI.TagInfo.self).asObservable(),
            modelDeselected: tableView.rx.modelDeselected(QiitaAPI.TagInfo.self).asObservable())
        return TagListViewModel(input: input)
    }()
    
    let disposeBag = DisposeBag()
    
    var selectedTags: Observable<[String]> {
        return _selectedTags.asObservable()
    }
    private let _selectedTags = PublishRelay<[String]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad.onNext(())
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.tags
            .bind(to: tableView.rx.items(cellIdentifier: QiitaTagCell.cellIdentifier, cellType: QiitaTagCell.self)) { row, tag, cell in
                cell.configure(tag)
            }.disposed(by: disposeBag)
        
        viewModel.selectedTags
            .bind(to: _selectedTags)
            .disposed(by: disposeBag)
        
        tableView.rx.didScroll.asObservable()
            .debounce(.milliseconds(500), scheduler: ConcurrentMainScheduler.instance)
            .bind(to: Binder(self) { me, _ in
                if me.tableView.isNearBottomEdge(edgeOffset: 500) {
                    me.viewModel.addTags.onNext(())
                }
            }).disposed(by: disposeBag)
        
        let me = self
        let modalClose = Observable.merge([
            cancelButton.rx.tap.asObservable().map { me },
            filterButton.rx.tap.asObservable().map { me }
            ])
        modalClose
            .bind(to: modalEvent.tagModalClose)
            .disposed(by: disposeBag)
    }
}
