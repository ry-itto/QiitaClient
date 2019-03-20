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
    
    fileprivate let host = URL(string: "https://qiita.com")
    
    let accessToken: String
    
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
        
        return Alamofire.request(requestURL!)
    }
    
    /// QiitaAPI v2 記事一覧検索
    /// https://qiita.com/api/v2/docs#get-apiv2items
    ///
    /// - Parameters:
    ///     - itemId: 記事ID
    func fetchArticle(itemId: String) -> DataRequest {
        let path = "/api/v2/items/\(itemId)"
        let requestURL = URL(string: path, relativeTo: host)
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return Alamofire.request(requestURL!)
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
        
        return Alamofire.request(requestURL!)
    }
}

