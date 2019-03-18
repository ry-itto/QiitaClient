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
    func fetchArticle(itemId: String) -> Observable<QiitaAPI.Article>
    func fetchArticles(query: String) -> Observable<[QiitaAPI.Article]>
}

class QiitaSearchDataProvider: QiitaSearchDataProviderProtocol {
    
    func fetchArticles(query: String) -> Observable<[QiitaAPI.Article]> {
        
        let gateway = QiitaAPIGateway.shared
        let decoder = gateway.decoder
        
        return Observable.create { observer -> Disposable in
            let request = gateway.fetchArticles(query: query)
            
            request.responseJSON { response in
                do {
                    let articles = try decoder.decode([QiitaAPI.Article].self, from: response.data!)
                    observer.onNext(articles)
                } catch let e {
                    observer.onError(e)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func fetchArticle(itemId: String) -> Observable<QiitaAPI.Article> {
        
        let gateway = QiitaAPIGateway.shared
        let decoder = gateway.decoder
        
        return Observable.create { observer -> Disposable in
            let request = gateway.fetchArticle(itemId: itemId)
            
            request.responseJSON { response in
                do {
                    let article = try decoder.decode(QiitaAPI.Article.self, from: response.data!)
                    observer.onNext(article)
                } catch let e {
                    observer.onError(e)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
