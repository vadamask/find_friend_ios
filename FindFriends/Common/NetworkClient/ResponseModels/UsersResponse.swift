//
//  User.swift
//  FindFriends
//
//  Created by Вадим Шишков on 03.04.2024.
//

import Foundation

struct UsersResponse: Decodable {
    struct User: Decodable {
        let id: Int
        let email: String
        let firstName: String
        let lastName: String
        let birthday: String?
        let sex: String
        let age: Int?
        let interests: [InterestsdResponse]
        let friends: [FriendsResponse]
        let friendsCount: Int
        let city: String?
        let avatar: String?
        let profession: String
        let purpose: String
        let networkNick: String?
        let additionally: String
        let isGeoipAllowed: Bool
        let isBlocked: Bool
        
        enum CodingKeys: String, CodingKey {
            case id, email, birthday, sex, age, interests, friends, city, avatar, profession, purpose, additionally
            case firstName = "first_name"
            case lastName = "last_name"
            case friendsCount = "friends_count"
            case networkNick = "network_nick"
            case isGeoipAllowed = "is_geoip_allowed"
            case isBlocked = "is_blocked"
        }
    }
    
    let count: Int
    let next: String?
    let previous: String?
    let results: [User]
}
