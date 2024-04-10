import Foundation

enum SelectedGender: String {
    case man = "М"
    case woman = "Ж"
}

final class EditMyProfileViewModel {
    
    @Published var selectedGenderInSetting: SelectedGender?
    
    func change(gender: SelectedGender) {
        selectedGenderInSetting = gender
    }
    
    
    @Published var textFieldText: String = ""
    @Published var buttonAndError: Bool = false
    
    
    func shouldHideKeyboard() -> Bool {
        return buttonAndError
    }
    
    func nextButtonTapped(_ date: String) {
        let components = date.components(separatedBy: ".")
        let formatted = components.reversed().joined(separator: "-")
    }
    
    func shouldChangeCharactersIn(text: String?, range: NSRange, replacementString: String) -> Bool {
        guard let text = text else { return false }
        
        let newString = NSString(string: text).replacingCharacters(in: range, with: replacementString)
        
        var count = 0
        for char in newString {
            if char == "." {
                count += 1
            }
        }
        if count > 2 {
            return false
        }
        
        switch ValidationService.validate(newString, type: .date) {
        case.failure(_):
            return false
        case .success():
            break
        }
        
        let newLength = text.count + replacementString.count - range.length
        
        if (newLength == 2 || newLength == 5) && replacementString != "." && count < 2 {
            if range.length == 0 {
                textFieldText = text + replacementString + "."
                return false
            }
        }
        
        switchErrorLabel(newString)
        
        return newLength <= 10
    }
    
    private func switchErrorLabel(_ string: String) {
        if string.count > 10 { return }
        if string == "" {
            buttonAndError = false
            return
        }
        let components = string.split(separator: ".")
        if components.count < 3 {
            buttonAndError = false
            return
        }
        
        let d = components[0]
        let m = components[1]
        let y = components[2]
        
        if d.count < 2 || m.count < 2 || y.count < 4 {
            buttonAndError = false
            return
        }
        
        guard let d = Int(d),
              let m = Int(m),
              let y = Int(y) else {
            buttonAndError = false
            return
        }
        
        let currnetY = Int(Calendar.current.component(.year, from: Date()))
        
        if d > 31 || m > 12 || y > currnetY || y < 1900 {
            buttonAndError = false
            return
        }
        
        buttonAndError = true
    }
}
