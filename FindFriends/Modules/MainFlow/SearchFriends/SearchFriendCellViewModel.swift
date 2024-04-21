import Foundation

final class SearchFriendCellViewModel {
    let fullName: String
    let age: Int?
    let avatar: String?
    let purpose: String
    
    init(fullName: String, age: Int?, avatar: String?, purpose: String) {
        self.fullName = fullName
        self.age = age
        self.avatar = avatar
        self.purpose = purpose
    }
}
