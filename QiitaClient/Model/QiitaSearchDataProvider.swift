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
    func fetchArticle(itemId: String) -> Observable<QiitaAPI.Article>
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
    
    func fetchArticle(itemId: String) -> Observable<QiitaAPI.Article> {
        return Observable.create { [weak self] observer -> Disposable in
            let request = self?.gateway.fetchArticle(itemId: itemId)
            request?.responseJSON { response in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let article = try decoder.decode(QiitaAPI.Article.self, from: response.data!)
                    observer.onNext(article)
                } catch let e {
                    observer.onError(e)
                }
            }
            return Disposables.create {
                request?.cancel()
            }
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
