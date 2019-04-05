//
//  AuthenticatedUserViewModel.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/30.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxSwift
import RxCocoa

final class AuthenticatedUserViewModelViewModel {
    
    private let disposeBag = DisposeBag()
    
    let viewDidLoad: AnyObserver<Void>
    let fetchUserInfo: Observable<QiitaAPI.AuthenticatedUserInfo>
    
    init(_ provider: AuthenticatedUserDataProviderProtocol = AuthenticatedUserDataProvider()) {
        
        let viewDidLoadSubject = PublishSubject<Void>()
        let fetchUserInfoSubject = PublishSubject<QiitaAPI.AuthenticatedUserInfo>()
        
        viewDidLoad = viewDidLoadSubject.asObserver()
        fetchUserInfo = fetchUserInfoSubject.asObservable()
        
        viewDidLoadSubject.asObservable()
            .flatMap { provider.fetchUserInfo().materialize() }
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
            .bind(to: fetchUserInfoSubject)
            .disposed(by: disposeBag)
    }
}
