//
//  QiitaAPIModels.swift
//  QiitaClient
//
//  Created by 伊藤凌也 on 2019/03/16.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation

struct QiitaAPI {
    
    struct Article: Decodable {
        let renderedBody: String
        let body: String
        let coediting: Bool
        let createdAt: Date
        let group: Group?
        let id: String
        let likesCount: Int
        let isPrivate: Bool
        let reactionsCount: Int
        let tags: [Tag]
        let title: String
        let updatedAt: Date
        let url: URL
        let user: User
        let pageViewsCount: Int?
        
        struct Group: Decodable {
            let createdAt: Date
            let id: Int
            let name: String
            let isPrivate: Bool
            let updatedAt: Date
            let urlName: String
            
            enum CodingKeys: String, CodingKey {
                case createdAt
                case id
                case name
                case isPrivate = "private"
                case updatedAt
                case urlName
            }
        }
        
        struct Tag: Decodable {
            let name: String
            let versions: [String]
        }
        
        struct User: Decodable {
            let description: String?
            let facebookId: String?
            let followeesCount: Int
            let followersCount: Int
            let githubLoginName: String?
            let id: String
            let itemsCount: Int
            let linkedinId: String?
            let location: String?
            let name: String
            let organization: String?
            let permanentId: Int
            let profileImageUrl: URL?
            let teamOnly: Bool
            let twitterScreenName: String?
            let websiteUrlString: String?
            
            var websiteUrl: URL? {
                guard let string = websiteUrlString,
                    !string.isEmpty else {
                    return nil
                }
                return URL(string: string)
            }
            
            enum CodingKeys: String, CodingKey {
                case description
                case facebookId
                case followeesCount
                case followersCount
                case githubLoginName
                case id
                case itemsCount
                case linkedinId
                case location
                case name
                case organization
                case permanentId
                case profileImageUrl
                case teamOnly
                case twitterScreenName
                case websiteUrlString = "website_url"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case renderedBody
            case body
            case coediting
            case createdAt
            case group
            case id
            case likesCount
            case isPrivate = "private"
            case reactionsCount
            case tags
            case title
            case updatedAt
            case url
            case user
            case pageViewsCount
        }
    }
    
    struct TagInfo: Decodable {
        let followersCount: Int
        let iconUrl: URL?
        let id: String
        let itemsCount: Int
    }
    
    struct AccessToken: Decodable {
        let clientId: String
        let scopes: [String]
        let token: String
    }
    
    enum APIError: Error {
        case decode
    }
}
