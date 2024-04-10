//
//  CityRequest.swift
//  FindFriends
//
//  Created by Вадим Шишков on 02.04.2024.
//

import Foundation

struct CityRequest: NetworkRequestProtocol {
    var endpoint: Endpoint = .cities
    var httpMethod: HttpMethod = .get
    var body: (any Encodable)? = nil
}
