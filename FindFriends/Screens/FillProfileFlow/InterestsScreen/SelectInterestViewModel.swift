//
//  SelectInterestViewModel.swift
//  FindFriends
//
//  Created by Vitaly on 06.03.2024.
//

import Combine
import Foundation

final class SelectInterestsViewModel {
    @Published var interestsIsSelected = false
    var interestsDidLoadPublisher = PassthroughSubject<Void, Never>()
    
    private var visibleCount = 15
    private var visibleInterests: [InterestsCellViewModel] = []
    private var choosenInterests: [InterestsCellViewModel] = []
    private var interestsProvider: InterestsServiceProviderProtocol?

    private var allInterests: [InterestsdDto] = [] {
        didSet {
            visibleInterests = allInterests
                .prefix(upTo: visibleCount)
                .map { InterestsCellViewModel(id: $0.id, name: $0.name) }
            interestsDidLoadPublisher.send()
        }
    }
    
    var numberOfItems: Int {
        visibleInterests.count
    }
    
    init(interestsProvider: InterestsServiceProviderProtocol? = InterestsServiceProvider()) {
        self.interestsProvider = interestsProvider
    }
    
    func getInterests() {
        interestsProvider?.getInterests() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(interests):
                self.allInterests = interests
            case let .failure(error):
                print("getInterests error: \(error)")
            }
        }
    }
    
    func cellDidTappedAt(_ indexPath: IndexPath) {
        let interest = visibleInterests[indexPath.row]
        interest.isSelected.toggle()
        if interest.isSelected {
            choosenInterests.append(interest)
        } else {
            choosenInterests.removeAll { $0.id == interest.id }
        }
        checkSelected()
    }
    
    func modelFor(_ indexPath: IndexPath) -> InterestsCellViewModel {
        visibleInterests[indexPath.row]
    }
    
    func searchFieldDidChanged(_ searchText: String) {
        if searchText.isEmpty {
            visibleInterests = Array(allInterests
                .prefix(upTo: min(allInterests.count, visibleCount)))
                .map { InterestsCellViewModel(id: $0.id, name: $0.name) }
        } else {
            visibleInterests = allInterests
                .filter { $0.name.hasPrefix(searchText) }
                .map { InterestsCellViewModel(id: $0.id, name: $0.name) }
        }
        interestsDidLoadPublisher.send()
    }
    
    func nextButtonTapped() {
        
    }
    
    func passButtonTapped() {
        
    }
    
    private func checkSelected() {
        interestsIsSelected = visibleInterests.contains { $0.isSelected }
    }
}
