//
//  QiitaTrendCollector.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/15.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import Alamofire
import Kanna
import RxSwift

protocol QiitaTrendDataProviderProtocol {
    func fetchQiitaTrendPageSource(span: QiitaTrendDataProvider.QiitaTrendURL) -> Observable<[Trend.TrendArticle]>
}

class QiitaTrendDataProvider: QiitaTrendDataProviderProtocol {
    
    enum QiitaTrendURL: String {
        case today = "https://qiita.com"
        case weekly = "https://qiita.com/?scope=weekly"
        case monthly = "https://qiita.com/?scope=monthly"
    }
    
    func fetchQiitaTrendPageSource(span: QiitaTrendURL) -> Observable<[Trend.TrendArticle]> {
        /// MARK- レスポンスで返ってくる日付がiso8601形式のため，dateDecodingStrategyを変更する。
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return Observable.create { observer -> Disposable in
            Alamofire.request(span.rawValue).responseString { response in
                guard let doc = try? HTML(html: response.value!, encoding: .utf8) else { return }
                let json = doc.xpath("//div[contains(@data-hyperapp-app, \"Trend\")]").first?["data-hyperapp-props"]
                
                observer.onNext(try! decoder.decode(Trend.self, from: (json?.data(using: .utf8))!).trend["edges"] ?? [])
            }
            return Disposables.create()
        }
    }
}

///MARK- https://qiita.com のdivのattributeのdata-hyperapp-propsに対応した構造体
struct Trend: Decodable {
    let trend: [String:[TrendArticle]]
    let scope: String
    
    struct TrendArticle: Codable {
        let followingLikers: [String]
        let isLikedByViewer: Bool
        let isNewArrival: Bool
        let hasCodeBlock: Bool
        let node: TrendArticleNode
        
        struct TrendArticleNode: Codable {
            let createdAt: Date
            let likesCount: Int
            let title: String
            let uuid: String
            let author: ArticleAuthor
            
            struct ArticleAuthor: Codable {
                let profileImageUrl: URL
                let urlName: String
            }
        }
    }
}
