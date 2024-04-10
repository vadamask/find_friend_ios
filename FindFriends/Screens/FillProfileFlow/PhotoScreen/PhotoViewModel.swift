//
//  PhotoViewModel.swift
//  FindFriends
//
//  Created by Вадим Шишков on 05.04.2024.
//

import Foundation

final class PhotoViewModel {
    private weak var delegate: FillProfileDelegate?
    private let service: UsersServiceProtocol
    
    init(service: UsersServiceProtocol = UsersService(), delegate: FillProfileDelegate) {
        self.delegate = delegate
        self.service = service
    }
    
    func avatarIsSelect(_ photoIsSelect: Bool) {
        delegate?.avatarIsSelect(photoIsSelect ? Data() : nil)
    }
}
