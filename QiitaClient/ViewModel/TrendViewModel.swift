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
    
    let viewDidLoad: AnyObserver<Void>
    
    init(_ provider: QiitaTrendDataProviderProtocol = QiitaTrendDataProvider()) {
        let viewDidLoadSubject = PublishSubject<Void>()
        let articlesRelay = BehaviorRelay<[Trend.TrendArticle]>(value: [])
        
        articles = articlesRelay.asObservable()
        
        viewDidLoad = viewDidLoadSubject.asObserver()
        
        viewDidLoadSubject.asObservable()
            .flatMap { provider.fetchQiitaTrendPageSource(span: .today) }
            .bind(to: articlesRelay)
            .disposed(by: disposeBag)
    }
}
