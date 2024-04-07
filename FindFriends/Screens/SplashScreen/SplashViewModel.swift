//
//  SplashViewModel.swift
//  FindFriends
//
//  Created by Вадим Шишков on 06.04.2024.
//

import Combine
import Foundation

final class SplashViewModel {
    
    enum SplashState {
        case login
        case unlogin
        case unfinishedRegistration
    }
    
    let fillingProfileKey = "fillingProfile"
    var username = PassthroughSubject<String, Never>()
    var state = PassthroughSubject<SplashState, Never>()
    
    private let service: UsersServiceProtocol
    private let oauthTokenStorage = OAuthTokenStorage.shared
    private let userDefaults = UserDefaults.standard
    
    init(service: UsersServiceProtocol = UsersService()) {
        self.service = service
    }
    
    func viewDidAppear() {
        if let _ = oauthTokenStorage.token {
            if userDefaults.bool(forKey: fillingProfileKey) {
                fetchUsername()
            } else {
                state.send(.unfinishedRegistration)
            }
        } else {
            state.send(.unlogin)
        }
    }
    
    func fetchUsername() {
        service.loadMyInfo { [unowned self] result in
            switch result {
            case .success(let user):
                self.username.send(user.firstName)
                state.send(.login)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
