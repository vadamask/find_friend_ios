//
//  FillProfileDto.swift
//  FindFriends
//
//  Created by Вадим Шишков on 02.04.2024.
//

import Foundation

struct FillProfileDto {
    let sex: String
    let birthday: String
    let interests: [InterestDto]
    let city: String?
    let avatar: Data?
}
