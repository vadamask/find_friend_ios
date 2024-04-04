//
//  Endpoints.swift
//  FindFriends
//
//  Created by Artem Novikov on 26.02.2024.
//


import Foundation

enum Endpoint {
    
    case login
    case getUsers(Int)
    case createUser
    case resetPassword
    case newPassword
    case interests
    case getUser
    case validateToken
    case cities
    case logout
    
    var baseURL: URL? {
        URL(string: "http://158.160.60.2/api/v1/")
    }
    
    var path: String {
        switch self {
        case .login: "auth/token/login/"
        case .getUsers(let page): "users/?page=\(page)"
        case .createUser: "users/"
        case .resetPassword: "users/reset_password/"
        case .newPassword: "users/reset_password/confirm/"
        case .interests: "interests/"
        case .getUser: "users/me/"
        case .validateToken: "users/reset_password/validate_token/"
        case .cities: "cities/"
        case .logout: "auth/token/logout/"
        }
    }
    
    var url: URL? {
        URL(string: path, relativeTo: baseURL)
    }
}
