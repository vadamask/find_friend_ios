//
//  FillProfileDto.swift
//  FindFriends
//
//  Created by Вадим Шишков on 02.04.2024.
//

import Foundation

struct FillProfileDto: Codable {
    let sex: String
    let birthday: String
    let interests: [Int]
    let city: Int?
    let avatar: Data?
}
