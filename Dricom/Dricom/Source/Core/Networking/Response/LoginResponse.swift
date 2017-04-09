import Unbox

struct LoginResponse: Unboxable {
    let jwt: String
    let user: User
    
    // MARK: - Unboxable
    init(unboxer: Unboxer) throws {
        jwt = try unboxer.unbox(key: "token")
        user = try unboxer.unbox(key: "user")
    }
}
