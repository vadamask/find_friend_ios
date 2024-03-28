//
//  SelectInterestViewModel.swift
//  FindFriends
//
//  Created by Vitaly on 06.03.2024.
//

import Combine
import Foundation

final class SelectInterestsViewModel {
    @Published var interestsDidLoad = false
    @Published var interestsIsSelected = false
    
    private(set) var showInterests: [InterestsCellViewModel] = []
    private var defaultCountIntrerests = 15
    private (set) var interestsProvider: InterestsServiceProviderProtocol?

    private var interests: [InterestsdDto] = [] {
        didSet {
            showInterests = Array(interests.prefix(upTo: min(interests.count, defaultCountIntrerests)))
                .map { InterestsCellViewModel(id: $0.id, name: $0.name)}
            interestsDidLoad = true
        }
    }
    
    init(interestsProvider: InterestsServiceProviderProtocol? = InterestsServiceProvider()) {
        self.interestsProvider = interestsProvider
    }
    
    func getInterests() {
        interestsProvider?.getInterests() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(interests):
                self.interests = interests
            case let .failure(error):
                print("getInterests error: \(error)")
            }
        }
    }
    
    func cellDidTappedAt(_ indexPath: IndexPath) {
        showInterests[indexPath.row].isSelected.toggle()
        countSelected()
    }
    
    private func countSelected() {
        interestsIsSelected = showInterests.contains { $0.isSelected }
    }
}
