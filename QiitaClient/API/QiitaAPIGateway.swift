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
    
    fileprivate static let host = URL(string: "https://qiita.com")
    
    let accessToken: String
    private static var decoder: JSONDecoder = JSONDecoder()
    
    init() {
        accessToken = UserDefaults.init().string(forKey: "qiita_access_token")!
    }
    
    /// QiitaAPI v2 記事一覧検索
    /// https://qiita.com/api/v2/docs#get-apiv2items
    ///
    /// - Parameters:
    ///     - page: 何ページ分か, default=1
    ///     - perPage: 1ページごとの記事数, default=20
    ///     - query: 検索クエリ, 必須
    ///     - after: APIリクエスト後の処理
    ///     - response: APIリクエスト結果, エラー時nil
    ///     - error: エラー内容, エラー時以外nil
    static func fetchArticles(page: Int = 1, perPage: Int = 20, query: String, after: @escaping (_ response: [QiitaAPI.Article], _ error: QiitaAPI.APIError?) -> Void) {
        let path = "/api/v2/items?page=\(page)&perPage=\(perPage)&query=\(query)"
        guard let requestURL = URL(string: path, relativeTo: host) else { return }
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        Alamofire.request(requestURL).responseJSON { response in
            do {
                let decoded = try decoder.decode([QiitaAPI.Article].self, from: response.data!)
                after(decoded, nil)
            } catch {
                after([], .decode)
            }
        }
    }
    
    /// QiitaAPI v2 タグ一覧取得
    /// https://qiita.com/api/v2/docs#get-apiv2tags
    ///
    /// - Parameters:
    ///     - after: APIリクエスト後の処理
    ///     - response: APIリクエスト結果 エラー時nil
    ///     - error: エラー内容　エラー時以外nil
    ///
    static func fetchTagList(after: @escaping (_ response: [QiitaAPI.TagInfo], _ error: QiitaAPI.APIError?) -> Void) {
        let path = "/api/v2/tags?sort=count"
        guard let requestURL = URL(string: path, relativeTo: host) else { return }
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        Alamofire.request(requestURL).responseJSON { response in
            do {
                let decoded = try decoder.decode([QiitaAPI.TagInfo].self, from: response.data!)
                after(decoded, nil)
            } catch {
                after([], .decode)
            }
        }
    }
}

