//
//  Config.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/23.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation

class QiitaConfig {
    
    static let shared = QiitaConfig()
    
    let clientId: String
    let clientSecret: String
    let redirectURL: URL

    // MARK: - 以下，開発者の設定の関係上なのでアプリ自体を落としている
    private init() {
        let filePath = Bundle.main.path(forResource: "Config", ofType: "plist")
        guard let config = NSDictionary(contentsOfFile: filePath!) else {
            fatalError("Cannot find configure file")
        }
        
        guard
            let clientId = config["client_id"] as? String,
            let clientSecret = config["client_secret"] as? String,
            let redirectURLString = config["redirect_url"] as? String else {
                fatalError("Cannot find client_id or client_secret of redirect_url in configure file")
        }
        
        guard let redirectURL = URL(string: redirectURLString) else {
            fatalError("Cannnot parse redirect_url to URL in configure file")
        }
        
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURL = redirectURL
    }
}
