//
//  ProfileRequest.swift
//  FindFriends
//
//  Created by Victoria Isaeva on 22.03.2024.
//

import Foundation

struct MyProfileRequest: NetworkRequestProtocol {
    let httpMethod: HttpMethod
    let endpoint = Endpoint.me
    let body: Encodable?
}
