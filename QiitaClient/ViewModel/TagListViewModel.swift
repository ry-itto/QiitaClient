//
//  TagListViewModel.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/20.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TagListViewModel {
    private let disposeBag = DisposeBag()
    
    typealias Input = (
        modelSelected: Observable<QiitaAPI.TagInfo>,
        modelDeselected: Observable<QiitaAPI.TagInfo>
    )
    
    let viewDidLoad: AnyObserver<Void>
    let addTags: AnyObserver<Void>
    let tags: Observable<[QiitaAPI.TagInfo]>
    
    let selectedTags: Observable<[String]>
    
    init(_ provider: TagListDataProviderProtocol = TagListDataProvider(),
         input: Input) {
        let selectedTags = BehaviorRelay<[String]>(value: [])
        self.selectedTags = selectedTags.asObservable()
        
        let viewDidLoadSubject = PublishSubject<Void>()
        let addTagsSubject = PublishSubject<Void>()
        let tagsRelay = BehaviorRelay<[QiitaAPI.TagInfo]>(value: [])
        
        var page = 1
        
        viewDidLoad = viewDidLoadSubject.asObserver()
        addTags = addTagsSubject.asObserver()
        tags = tagsRelay.asObservable()
        
        viewDidLoadSubject.asObservable()
            .flatMap { provider.fetchTagList(page: 1) }
            .materialize()
            .subscribe(onNext: { event in
                switch event {
                case let .next(element):
                    page = 2
                    tagsRelay.accept(element)
                case .error:
                    break
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        addTagsSubject.asObservable()
            .flatMap { provider.fetchTagList(page: page) }
            .materialize()
            .subscribe(onNext: { event in
                switch event {
                case let .next(element):
                    page += 1
                    tagsRelay.accept(tagsRelay.value + element)
                case .error:
                    break
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        input.modelSelected
            .map { tag in tag.id }
            .withLatestFrom(selectedTags) { $1 + [$0] }
            .bind(to: selectedTags)
            .disposed(by: disposeBag)
        
        input.modelDeselected
            .map { tag in tag.id }
            .withLatestFrom(selectedTags) { ($0, $1) }
            .flatMap { id, tags -> Observable<[String]> in
                guard let index = tags.index(of: id) else {
                    return .empty()
                }
                var _tags = tags
                _tags.remove(at: index)
                return .just(_tags)
            }
            .bind(to: selectedTags)
            .disposed(by: disposeBag)
    }
}
