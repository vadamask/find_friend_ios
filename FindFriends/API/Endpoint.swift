import Foundation

enum Endpoint {
    
    // auth
    case login
    case logout
    
    // chats
    case getChats
    case startChat
    case getChatById(Int)
    
    // cities
    case getCities
    case getCityById(Int)
    
    // events
    case getEvents(Int)
    case getEventById(Int)
    case createEvent(Int)
    case updateEvent(Int)
    case deleteEvent(Int)
    case getDistances(Int)
    case getDistanceToEvent(Int)
    case getGeoOfEvent(Int)
    
    // friends
    case getFriends
    case createFriend
    case acceptFriend(Int)
    case declineFriend(Int)
    
    // interests
    case getInterests
    case getInterestById(Int)
    
    // notification
    case getNotifications
    case createNotification
    case getNotificationById(Int)
    case deleteNotificationById(Int)
    
    // participation
    case getParticipation
    case createParticipation
    case acceptParticipation(Int)
    case declineParticipation(Int)
    
    // users
    case getUsers(Int)
    case getUserById(Int)
    case getDistancesToUsers(Int)
    case getDistanceToUser(Int)
    case getUserGeo(Int)
    
    // me
    case createUser
    case getMe
    case updateMe
    case deleteMe
    case getMyEvents
    case getMyFriends
    
    // blacklist
    case getBlacklist(Int)
    case blockUser(Int)
    case deleteUserFromBlacklist(Int)
    
    // reset password
    case resetPassword
    case validateToken
    case setPassword
}

// MARK: - PATH

extension Endpoint {
    var url: URL? {
        URL(string: path, relativeTo: baseURL)
    }
    
    private var baseURL: URL? {
        URL(string: "http://94.241.142.3/api/v1/")
    }
    
    private var path: String {
        switch self {
        case .login: "auth/token/login/"
        case .logout: "auth/token/logout/"
            
        case .getChats: "chats/"
        case .startChat: "chats/start/"
        case .getChatById(let id): "chats/\(id)"
            
        case .getCities: "cities/"
        case .getCityById(let id): "cities/\(id)/"
            
        case .getEvents(let page): "events/\(page)"
        case .getEventById(let id): "events/\(id)/"
        case .createEvent: "events/"
        case .updateEvent(let id): "events/\(id)/"
        case .deleteEvent(let id): "events/\(id)/"
        case .getDistances(let page): "events/\(page)"
        case .getDistanceToEvent(let id): "events/\(id)/distance/"
        case .getGeoOfEvent(let id): "events/\(id)/geolocation/"
            
        case .getFriends: "friends/"
        case .createFriend: "friends/"
        case .acceptFriend(let id): "friends/\(id)/accept/"
        case .declineFriend(let id): "friends/\(id)/decline/"
            
        case .getInterests: "interests/"
        case .getInterestById(let id): "interests/\(id)/"
            
        case .getNotifications: "notification/"
        case .createNotification: "notification/"
        case .getNotificationById(let id): "notification/\(id)/"
        case .deleteNotificationById(let id): "notification/\(id)/"
            
        case .getParticipation: "participation/"
        case .createParticipation: "participation/"
        case .acceptParticipation(let id): "participation/\(id)/accept/"
        case .declineParticipation(let id): "participation/\(id)/decline/"
            
        case .getUsers(let page): "users/?page=\(page)"
        case .getUserById(let id): "users/\(id)/"
        case .getDistancesToUsers(let page): "users/distances/\(page)"
        case .getDistanceToUser(let id): "users/\(id)/distance/"
        case .getUserGeo(let id): "users/\(id)/geolocation/"
            
        case .createUser: "users/"
        case .getMe: "users/me/"
        case .updateMe: "users/me/"
        case .deleteMe: "users/me/"
        case .getMyEvents: "users/my_events/"
        case .getMyFriends: "users/my_friends/"
            
        case .getBlacklist(let page): "users/blacklist/\(page)/"
        case .blockUser(let id): "users/\(id)/block/"
        case .deleteUserFromBlacklist(let id): "users/\(id)/block/"
            
        case .resetPassword: "users/reset_password/"
        case .validateToken: "users/reset_password/validate_token/"
        case .setPassword: "users/reset_password/confirm/"
        }
    }
}

// MARK: - HTTP Method

extension Endpoint {
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    var method: HttpMethod {
        switch self {
        case .login: .post
        case .logout: .post
            
        case .getChats: .get
        case .startChat: .post
        case .getChatById(_): .get
            
        case .getCities: .get
        case .getCityById(_): .get
            
        case .getEvents(_): .get
        case .getEventById(_): .get
        case .createEvent(_): .post
        case .updateEvent(_): .put
        case .deleteEvent(_): .delete
            
        case .getDistances(_): .get
        case .getDistanceToEvent(_): .get
        case .getGeoOfEvent(_): .get
            
        case .getFriends: .get
        case .createFriend: .post
        case .acceptFriend(_): .post
        case .declineFriend(_): .post
            
        case .getInterests: .get
        case .getInterestById(_): .get
            
        case .getNotifications: .get
        case .createNotification: .post
        case .getNotificationById(_): .get
        case .deleteNotificationById(_): .delete
            
        case .getParticipation: .get
        case .createParticipation: .post
        case .acceptParticipation(_): .post
        case .declineParticipation(_): .post
            
        case .getUsers(_): .get
        case .getUserById(_): .get
        case .getDistancesToUsers(_): .get
        case .getDistanceToUser(_): .get
        case .getUserGeo(_): .get
            
        case .createUser: .post
        case .getMe: .get
        case .updateMe: .put
        case .deleteMe: .delete
        case .getMyEvents: .get
        case .getMyFriends: .get
            
        case .getBlacklist(_): .get
        case .blockUser(_): .post
        case .deleteUserFromBlacklist(_): .delete
            
        case .resetPassword: .post
        case .validateToken: .post
        case .setPassword: .post
        }
    }
}
