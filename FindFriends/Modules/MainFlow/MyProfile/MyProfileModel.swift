import Foundation

final class MyProfileModel {
    let fullName: String
    let age: Int?
    let avatar: String?
    let purpose: String
    let interests: [InterestsdResponse]
    let friends: [FriendsResponse]
    let friendsCount: Int
    let city: String?
    let profession: String
    let networkNick: String?
    
    init(fullName: String, age: Int?, avatar: String?, purpose: String, interests: [InterestsdResponse], friends: [FriendsResponse], friendsCount: Int, city: String?, profession: String, networkNick: String?) {
        self.fullName = fullName
        self.age = age
        self.avatar = avatar
        self.purpose = purpose
        self.interests = interests
        self.friends = friends
        self.friendsCount = friendsCount
        self.city = city
        self.profession = profession
        self.networkNick = networkNick
    }
}

final class InterestsModel {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

final class FriendsModel {
    let id: Int
    let firstName: String
    let lastName: String
    let age: Int
    
    init(id: Int, firstName: String, lastName: String, age: Int) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
}


