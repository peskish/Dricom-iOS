import Alamofire

struct ChangePasswordRequest: NetworkRequest {
    typealias Result = LoginResponse
    
    private let oldPassword: String
    private let newPassword: String
    
    init(
        oldPassword: String,
        newPassword: String)
    {
        self.oldPassword = oldPassword
        self.newPassword = newPassword
    }
    
    let httpMethod: HTTPMethod = .post
    let isAuthorizationRequired = true
    let path = "change-password"
    
    var params: [String: Any] {
        var parameters = [String: Any]()
        parameters["old_password"] = oldPassword
        parameters["new_password"] = newPassword
        return parameters
    }
}
