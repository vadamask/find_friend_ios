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
        delegate?.showNextViewController()
    }
    
    enum SelectedGender: String {
        case man = "М"
        case woman = "Ж"
    }
}

