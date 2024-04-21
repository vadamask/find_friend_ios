import Combine
import Foundation

final class SelectInterestsViewModel {
    @Published var interestsIsSelected = false
    var interestsDidLoadPublisher = PassthroughSubject<Void, Never>()
    
    private var visibleCount = 15
    private var visibleInterests: [InterestsCellViewModel] = []
    private var choosenInterests: Set<InterestsCellViewModel> = []
    private var interestsProvider: InterestsServiceProtocol
    private weak var delegate: FillProfileDelegate?

    private var allInterests: [InterestsCellViewModel] = [] {
        didSet {
            visibleInterests = allInterests
                .prefix(upTo: 15)
                .map { $0 }
            interestsDidLoadPublisher.send()
        }
    }
    
    var numberOfItems: Int {
        visibleInterests.count
    }
    
    init(interestsProvider: InterestsServiceProtocol = InterestsService(), delegate: FillProfileDelegate) {
        self.interestsProvider = interestsProvider
        self.delegate = delegate
    }
    
    func getInterests() {
        interestsProvider.getInterests() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(interests):
                self.allInterests = interests
            case let .failure(error):
                print("getInterests error: \(error)")
            }
        }
    }
    
    func didSelectItemAt(_ indexPath: IndexPath) {
        let interest = visibleInterests[indexPath.row]
        if interest.isSelected.value {
            interest.isSelected.send(false)
            choosenInterests.remove(interest)
        } else {
            interest.isSelected.send(true)
            choosenInterests.insert(interest)
        }
        
        interestsIsSelected = !choosenInterests.isEmpty
    }
    
    func modelFor(_ indexPath: IndexPath) -> InterestsCellViewModel {
        visibleInterests[indexPath.row]
    }
    
    func searchFieldDidChanged(_ searchText: String) {
        if searchText.isEmpty {
            visibleInterests = allInterests
                .prefix(upTo: 15)
                .map { $0 }
        } else {
            visibleInterests = allInterests
                .filter { $0.name.hasPrefix(searchText) }
        }
        interestsDidLoadPublisher.send()
    }
    
    func nextButtonTapped() {
        delegate?.interestsIsSelect(choosenInterests.map { InterestDto(id: $0.id, name: $0.name) })
        delegate?.showNextViewController()
    }
    
    func passButtonTapped() {
        delegate?.interestsIsSelect([])
        delegate?.showNextViewController()
    }
}
