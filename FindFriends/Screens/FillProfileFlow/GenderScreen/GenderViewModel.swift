//
//  GenderViewModel.swift
//  FindFriends
//
//  Created by Ognerub on 3/4/24.
//

import Foundation

final class GenderViewModel {
    @Published var selectedGender: SelectedGender?
    private weak var delegate: FillProfileDelegate?
    
    init(delegate: FillProfileDelegate) {
        self.delegate = delegate
    }
    
    func change(gender: SelectedGender) {
        selectedGender = gender
    }
    
    func nextButtonTapped() {
        delegate?.genderIsSelect(selectedGender?.rawValue ?? "")
        delegate?.showControllerWithIndex(1)
    }
    
    enum SelectedGender: String {
        case man = "М"
        case woman = "Ж"
    }
}

