import Alamofire

struct AuthRequest: NetworkRequest {
    typealias Result = LoginResponse
    
    private let email: String
    private let password: String
    
    init(
        email: String,
        password: String
        )
    {
        self.email = email
        self.password = password
    }
    
    let version = 1
    let httpMethod: HTTPMethod = .post
    let isAuthorizationRequired = false
    let path = "auth"
    
    var params: [String: Any] {
        var parameters = [String: Any]()
        parameters["email"] = email
        parameters["password"] = password
        return parameters
    }
}
