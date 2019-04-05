//
//  AuthenticatedUserDataProvider.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/30.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AuthenticatedUserDataProviderProtocol {
    func fetchUserInfo() -> Observable<QiitaAPI.AuthenticatedUserInfo>
}

class AuthenticatedUserDataProvider: AuthenticatedUserDataProviderProtocol {
    
    let gateway = QiitaAPIGateway.shared
    
    func fetchUserInfo() -> Observable<QiitaAPI.AuthenticatedUserInfo> {
        
        let decoder = gateway.decoder
        
        return Observable.create { [weak self] observer -> Disposable in
            let request = self?.gateway.authenticatedUser()
            
            request?.responseJSON { response in
                do {
                    let userInfo = try decoder.decode(QiitaAPI.AuthenticatedUserInfo.self, from: response.data!)
                    observer.onNext(userInfo)
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
