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
import UIKit

class ModalEventWrapper {
    var tagModalClose = PublishRelay<TagListViewController>()
    var loginModalClose = PublishRelay<LoginViewController>()
    
    static let instance = ModalEventWrapper()
    
    private init() {}
}
