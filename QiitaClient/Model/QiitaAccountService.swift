//
//  QiitaAccountService.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/21.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol QiitaAccountServiceProtocol {
    func fetchAccessToken(from redirectURL: URL)
}

class QiitaAccountService: QiitaAccountServiceProtocol {
    func fetchAccessToken(from redirectURL: URL) {
        let gateway = QiitaAPIGateway.shared
        let urlComponents = URLComponents(string: redirectURL.absoluteString)
        let decoder = gateway.decoder
        guard let code = urlComponents?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        print(redirectURL.absoluteString)
        print(code)
        gateway.fetchAccessToken(code: code).responseJSON { response in
            let accessTokenResponse = try? decoder.decode(QiitaAPI.AccessToken.self, from: response.data!)
            // 取得したアクセストークンをユーザーデフォルトに保存
            guard let at = accessTokenResponse else { return }
            UserDefaults.standard.set(at.token, forKey: "qiita_access_token")
        }
        
    }
}
