//
//  NewPasswordSuccessViewModel.swift
//  FindFriends
//
//  Created by Вадим Шишков on 18.04.2024.
//

import Foundation

final class NewPasswordSuccessViewModel {
    private let coordinator: AuthCoordinatorProtocol
    
    init(coordinator: AuthCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func didTapLogInButton() {
        coordinator.popToLoginVC()
    }
}
