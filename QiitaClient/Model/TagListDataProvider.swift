//
//  TagListDataProvider.swift
//  QiitaClientApp
//
//  Created by 伊藤凌也 on 2019/03/20.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TagListDataProviderProtocol {
    func fetchTagList(page: Int) -> Observable<[QiitaAPI.TagInfo]>
}

class TagListDataProvider: TagListDataProviderProtocol {
    let gateway = QiitaAPIGateway.shared
    
    func fetchTagList(page: Int) -> Observable<[QiitaAPI.TagInfo]> {
        
        let decoder = gateway.decoder
        
        return Observable.create { [weak self] observer -> Disposable in
            let request = self?.gateway.fetchTagList(page: page)
            request?.responseJSON { response in
                do {
                    let tags = try decoder.decode([QiitaAPI.TagInfo].self, from: response.data!)
                    observer.onNext(tags)
                } catch let e {
                    observer.onError(e)
                }
            }
            return Disposables.create {
                request?.cancel()
            }
        }
    }
}
