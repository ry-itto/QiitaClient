//
//  ModalEventWrapper.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/20.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ModalEventWrapper {
    var modalClose = PublishRelay<TagListViewController>()
    
    static let instance = ModalEventWrapper()
    
    private init() {}
}
