// MARK: - SessionInfo -

struct SessionInfo: Equatable {
    
    let session: String
    let user: User
    
    // MARK: Equatable
    static func ==(left: SessionInfo, right: SessionInfo) -> Bool {
        return left.session == right.session &&
            left.user == right.user
    }
}
