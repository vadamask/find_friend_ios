import Foundation

final class GenderViewModel {
    @Published var selectedGender: Gender?
    private weak var delegate: FillProfileDelegate?
    
    init(delegate: FillProfileDelegate) {
        self.delegate = delegate
    }
    
    func boyDidSelect() {
        selectedGender = .boy
    }
    
    func girlDidSelect() {
        selectedGender = .girl
    }
    
    func nextButtonTapped() {
        delegate?.genderIsSelect(selectedGender?.rawValue ?? "")
        delegate?.showNextViewController()
    }
}

enum Gender: String {
    case boy = "М"
    case girl = "Ж"
}
