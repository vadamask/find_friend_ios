//
//  CellViewModel.swift
//  FindFriends
//
//  Created by Вадим Шишков on 28.03.2024.
//

import Combine
import Foundation

struct InterestsCellViewModel: Hashable {
    var isSelected = CurrentValueSubject<Bool, Never>(false)
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: InterestsCellViewModel, rhs: InterestsCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
