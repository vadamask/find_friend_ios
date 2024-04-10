//
//  LogoutRequest.swift
//  FindFriends
//
//  Created by Вадим Шишков on 04.04.2024.
//

import Foundation

struct LogoutRequest: NetworkRequestProtocol {
    let httpMethod: HttpMethod = .post
    let endpoint: Endpoint = .logout
    let body: Encodable? = nil
}
