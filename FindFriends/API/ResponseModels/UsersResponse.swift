//
//  User.swift
//  FindFriends
//
//  Created by Вадим Шишков on 03.04.2024.
//

import Foundation

struct UsersResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [UserResponse]
}
