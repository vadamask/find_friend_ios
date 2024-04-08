import Foundation

final class EditMyProfileViewModel {

        @Published var selectedGenderInSetting: SelectedGender?
       
        func change(gender: SelectedGender) {
            selectedGenderInSetting = gender
        }
        
    enum SelectedGender: String {
        case man = "М"
        case woman = "Ж"
    }
}
