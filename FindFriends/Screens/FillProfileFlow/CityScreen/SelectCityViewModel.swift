//
//  SelectCityViewModel.swift
//  FindFriends
//
//  Created by Вадим Шишков on 07.04.2024.
//

import Foundation

final class SelectCityViewModel {
    @Published var selectCity: CityResponse?
    private weak var delegate: FillProfileDelegate?
    
    init(delegate: FillProfileDelegate) {
        self.delegate = delegate
    }
    
    func nextButtonTapped() {
        delegate?.cityIsSelect(selectCity?.name)
        delegate?.showNextViewController()
    }
    
    func skipButtonTapped() {
        delegate?.cityIsSelect(nil)
        delegate?.showNextViewController()
    }
    
    func cancelButtonClicked() {
        selectCity = nil
    }
}

extension SelectCityViewModel: CityViewControllerDelegate {
    func acceptCity(_ city: CityResponse) {
        selectCity = city
    }
}
