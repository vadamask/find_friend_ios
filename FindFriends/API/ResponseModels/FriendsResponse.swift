//
//  Friend.swift
//  FindFriends
//
//  Created by Вадим Шишков on 03.04.2024.
//

import Foundation

struct FriendsResponse: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let age: Int
    
    enum CodingKeys: String, CodingKey {
        case id, age
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
