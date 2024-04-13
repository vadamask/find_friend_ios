//
//  ErrorModel.swift
//  FindFriends
//
//  Created by Вадим Шишков on 13.03.2024.
//

import Foundation

struct ErrorModel: Decodable {
    let password: [String]?
    let email: [String]?
    let nonFieldErrors: [String]?
    let detail: String?
    
    
    var currentError: String {
        if let email {
            return email.joined(separator: " ")
        } else if let password {
            return password.joined(separator: " ")
        } else if let nonFieldErrors {
            return nonFieldErrors.joined(separator: " ")
        } else if let detail {
            return detail
        } else {
            return "Неизвестная ошибка"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case password, email, detail
        case nonFieldErrors = "non_field_errors"
    }
}
