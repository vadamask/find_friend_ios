//
//  Coordinator.swift
//  FindFriends
//
//  Created by Вадим Шишков on 13.04.2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var parent: Coordinator? { get }
    var childs: [Coordinator] { get }
    func start()
}
