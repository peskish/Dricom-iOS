struct User: Equatable {
    let userId: String
    let avatar: String?
    let userName: String?
    let licence: String?
    let phone: String?
    
    // MARK: Equatable
    static func ==(left: User, right: User) -> Bool {
        return left.userId == right.userId &&
            left.avatar == right.avatar &&
            left.licence == right.licence &&
            left.userName == right.userName &&
            left.phone == right.phone
    }
}
