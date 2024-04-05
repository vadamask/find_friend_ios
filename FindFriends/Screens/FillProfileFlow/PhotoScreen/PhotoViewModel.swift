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
    
    init(service: UsersServiceProtocol = UsersService()) {
        self.service = service
    }
    
    func addPhoto() {
        
    }
    
    func deletePhoto() {
        
    }
    
    func finishFlow() {
        
    }
    
    func avatarIsSelect(_ photoIsSelect: Bool) {
        
    }
}
