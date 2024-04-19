//
//  Coordinator.swift
//  FindFriends
//
//  Created by Вадим Шишков on 13.04.2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
    func showAlert(_ message: String)
}

extension Coordinator {
    func showAlert(_ message: String) {
        AlertPresenter.show(in: navigationController, model: AlertModel(message: message))
    }
}
