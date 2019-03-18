//
//  QiitaSearchDataProvider.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/16.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol QiitaSearchDataProviderProtocol {
    func fetchTagList() -> Observable<[QiitaAPI.TagInfo]>
    func fetchArticles(query: String) -> Observable<[QiitaAPI.Article]>
}

class QiitaSearchDataProvider: QiitaSearchDataProviderProtocol {
    
    let gateway = QiitaAPIGateway()
    
    func fetchArticles(query: String) -> Observable<[QiitaAPI.Article]> {
        return Observable.create { [weak self] observer -> Disposable in
            self?.gateway.fetchArticles(query: query) { articles, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(articles)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchTagList() -> Observable<[QiitaAPI.TagInfo]> {
        return Observable.create { [weak self] observer -> Disposable in
            self?.gateway.fetchTagList { result, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(result)
                }
            }
            return Disposables.create()
        }
    }
}
