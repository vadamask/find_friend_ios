//
//  UpdateMyProfileDTO.swift
//  FindFriends
//
//  Created by Вадим Шишков on 07.04.2024.
//

import Foundation

struct UpdateMyProfileDto: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let sex: String
    let birthday: String
    let interests: [InterestDto]
    let city: String?
    let avatar: Data?

    enum CodingKeys: String, CodingKey {
        case email, sex, birthday, interests, city, avatar
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
