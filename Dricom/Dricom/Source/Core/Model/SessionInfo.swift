// MARK: - SessionInfo -

struct SessionInfo: Equatable {
    
    // MARK: Session
    let session: String?
    
    // MARK: User
    let userName: String?
    let licence: String?
    let phone: String?
    
    // MARK: Equatable
    static func ==(left: SessionInfo, right: SessionInfo) -> Bool {
        return left.session == right.session &&
            left.userName == right.userName &&
            left.licence == right.licence &&
            left.phone == right.phone
    }
}
