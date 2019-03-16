//
//  SearchViewModel.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/16.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    private let disposeBag = DisposeBag()
    
    let searchResult: Observable<[QiitaAPI.Article]>
    
    init(_ provider: QiitaSearchDataProviderProtocol = QiitaSearchDataProvider(), search: Observable<String>) {
        let searchResultRelay = BehaviorRelay<[QiitaAPI.Article]>(value: [])
        
        searchResult = searchResultRelay.asObservable()
        
        search
            .distinctUntilChanged()
            .debounce(0.3, scheduler: ConcurrentMainScheduler.instance)
            .flatMap { query in provider.fetchArticles(query: query)}
            .asDriver(onErrorJustReturn: [])
            .drive(searchResultRelay)
            .disposed(by: disposeBag)
    }
}
