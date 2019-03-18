//
//  TrendViewModel.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/15.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TrendViewModel {
    
    private let disposeBag = DisposeBag()
    
    let articles: Observable<[Trend.TrendArticle]>
    let showWebView: Observable<URL>
    
    let viewDidLoad: AnyObserver<Void>
    
    init(_ trendProvider: QiitaTrendDataProviderProtocol = QiitaTrendDataProvider(),
         _ searchProvider: QiitaSearchDataProviderProtocol = QiitaSearchDataProvider(),
         modelSelected: Observable<Trend.TrendArticle>) {
        let viewDidLoadSubject = PublishSubject<Void>()
        let showWebViewSubject = PublishSubject<URL>()
        let articlesRelay = BehaviorRelay<[Trend.TrendArticle]>(value: [])
        
        articles = articlesRelay.asObservable()
        showWebView = showWebViewSubject.asObservable()
        
        viewDidLoad = viewDidLoadSubject.asObserver()
        
        viewDidLoadSubject.asObservable()
            .flatMap { trendProvider.fetchQiitaTrendPageSource(span: .today) }
            .bind(to: articlesRelay)
            .disposed(by: disposeBag)
        
        modelSelected
            .flatMap { searchProvider.fetchArticle(itemId: $0.node.uuid) }
            .map { $0.url }
            .bind(to: showWebViewSubject.asObserver())
            .disposed(by: disposeBag)
    }
}
