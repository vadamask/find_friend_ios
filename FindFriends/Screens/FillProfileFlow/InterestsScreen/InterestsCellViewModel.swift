//
//  CellViewModel.swift
//  FindFriends
//
//  Created by Вадим Шишков on 28.03.2024.
//

import Foundation

class InterestsCellViewModel {
    @Published var isSelected: Bool = false
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
