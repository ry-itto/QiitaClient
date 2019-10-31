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
    
    typealias Input = (
        search: Observable<String>,
        selectedTags: Observable<[String]>
    )
    
    let searchResult: Observable<[QiitaAPI.Article]>
    let searchWithTag: Observable<[QiitaAPI.Article]>
    
    let addArticles: AnyObserver<String>
    
    
    init(_ provider: QiitaSearchDataProviderProtocol = QiitaSearchDataProvider(),
         input: Input) {
        let searchResultRelay = BehaviorRelay<[QiitaAPI.Article]>(value: [])
        let searchWithTagRelay = BehaviorRelay<[QiitaAPI.Article]>(value: [])
        let selectedTags = BehaviorRelay<[String]>(value: [])
        let addArticlesSubject = PublishSubject<String>()
        
        var page = 1
        
        addArticles = addArticlesSubject.asObserver()
        searchResult = searchResultRelay.asObservable()
        searchWithTag = searchWithTagRelay.asObservable()
        
        input.selectedTags
            .bind(to: selectedTags)
            .disposed(by: disposeBag)
        
        selectedTags
            .subscribe(onNext: { tagNames in
                let filteredResult = searchResultRelay.value.filter { article -> Bool in
                    var isContain = false
                    article.tags.forEach { tag in
                        if tagNames.contains(tag.name) {
                            isContain = true
                        }
                    }
                    return isContain
                }
                searchResultRelay.accept(filteredResult)
            }).disposed(by: disposeBag)
        
        input.search
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: ConcurrentMainScheduler.instance)
            .flatMap { query -> Observable<[QiitaAPI.Article]> in
                page = 2
                return provider.fetchArticles(page: 1, query: query)
            }
            .asDriver(onErrorJustReturn: [])
            .drive(searchResultRelay)
            .disposed(by: disposeBag)
        
        addArticlesSubject.asObservable()
            .flatMap { query in provider.fetchArticles(page: page, query: query) }
            .subscribe(onNext: { articles in
                page += 1
                searchResultRelay.accept(searchResultRelay.value + articles)
            }).disposed(by: disposeBag)
    }
}
