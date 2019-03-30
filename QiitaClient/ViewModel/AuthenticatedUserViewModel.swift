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
    
    init(_ provider: UserProfileDataProviderProtocol = UserProfileDataProvider()) {
        
        let viewDidLoadSubject = PublishSubject<Void>()
        let fetchUserInfoSubject = PublishSubject<QiitaAPI.AuthenticatedUserInfo>()
        
        viewDidLoad = viewDidLoadSubject.asObserver()
        fetchUserInfo = fetchUserInfoSubject.asObservable()
        
        viewDidLoadSubject.asObservable()
            .flatMap { provider.fetchUserInfo() }
            .materialize()
            .subscribe(onNext: { event in
                switch event {
                case let .next(element):
                    fetchUserInfoSubject.onNext(element)
                case .error:
                    break
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
}
