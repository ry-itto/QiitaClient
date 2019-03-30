//
//  QiitaAPIGateway.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/14.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import Alamofire

final class QiitaAPIGateway {
    
    fileprivate static let config = QiitaConfig.shared
    
    fileprivate let host = URL(string: "https://qiita.com")
    fileprivate let clientId = config.clientId
    fileprivate let clientSecret = config.clientSecret
    fileprivate let scope = "read_qiita write_qiita"
    
    let accessToken: String
    
    lazy var headers = [
        "Authorization" : "Bearer \(accessToken)"
    ]
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private init() {
        accessToken = UserDefaults.standard.string(forKey: "qiita_access_token")!
    }
    
    static let shared = QiitaAPIGateway()
    
    /// QiitaAPI v2 認証認可URL
    var authorizeURL: URL? {
        var components = URLComponents(string: "https://qiita.com/api/v2/oauth/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "scope", value: scope)
        ]
        
        return components?.url
    }
    
    /// QiitaAPI v2 アクセストークン取得
    /// https://qiita.com/api/v2/docs#post-apiv2access_tokens
    ///
    func fetchAccessToken(code: String) -> DataRequest {
        let path = "/api/v2/access_tokens"
        let requestURL = URL(string: path, relativeTo: host)
        let parameters = [
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "code" : code
        ]
        
        let headers = [
            "Content-Type" : "application/json"
        ]
        
        /// MARK:- encodingを指定する必要があった.
        return Alamofire.request(requestURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default,  headers: headers)
    }
    
    /// QiitaAPI v2 認証ユーザ取得
    /// https://qiita.com/api/v2/docs#get-apiv2authenticated_user
    func authenticatedUser() -> DataRequest {
        let path = "/api/v2/authenticated_user"
        let requestURL = URL(string: path, relativeTo: host)
        
        return Alamofire.request(requestURL!, headers: headers)
    }
    
    /// QiitaAPI v2 認証ユーザ記事一覧
    /// https://qiita.com/api/v2/docs#get-apiv2authenticated_useritems
    func authenticatedUserItems() -> DataRequest {
        let path = "/api/v2/authenticated_user/items"
        let requestURL = URL(string: path, relativeTo: host)
        
        return Alamofire.request(requestURL!, headers: headers)
    }
    
    /// QiitaAPI v2 記事一覧検索
    /// https://qiita.com/api/v2/docs#get-apiv2items
    ///
    /// - Parameters:
    ///     - page: 何ページ分か, default=1
    ///     - perPage: 1ページごとの記事数, default=20
    ///     - query: 検索クエリ, 必須
    func fetchArticles(page: Int = 1, perPage: Int = 20, query: String) -> DataRequest {
        let path = "/api/v2/items?page=\(page)&perPage=\(perPage)&query=\(query)"
        let requestURL = URL(string: path, relativeTo: host)
        
        return Alamofire.request(requestURL!, headers: headers)
    }
    
    /// QiitaAPI v2 記事一覧検索
    /// https://qiita.com/api/v2/docs#get-apiv2items
    ///
    /// - Parameters:
    ///     - itemId: 記事ID
    func fetchArticle(itemId: String) -> DataRequest {
        let path = "/api/v2/items/\(itemId)"
        let requestURL = URL(string: path, relativeTo: host)
        
        return Alamofire.request(requestURL!, headers: headers)
    }
    
    /// QiitaAPI v2 タグ一覧取得
    /// https://qiita.com/api/v2/docs#get-apiv2tags
    ///
    /// - Parameters:
    ///     - page: 何ページ分か, default=1
    ///     - perPage: 1ページごとの記事数, default=20
    ///
    func fetchTagList(page: Int = 1, perPage: Int = 20) -> DataRequest {
        let path = "/api/v2/tags?sort=count&page=\(page)&perPage=\(perPage)"
        let requestURL = URL(string: path, relativeTo: host)
        
        return Alamofire.request(requestURL!, headers: headers)
    }
}

