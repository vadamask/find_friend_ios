//
//  InterestsRequest.swift
//  FindFriends
//
//  Created by Вадим Шишков on 28.03.2024.
//

import Foundation

struct InterstsRequest: NetworkRequestProtocol {
    let httpMethod: HttpMethod = .get
    let endpoint = Endpoint.interests
    let body: Encodable? = nil
}
