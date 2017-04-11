import Alamofire

struct AuthRequest: NetworkRequest {
    typealias Result = LoginResponse
    
    private let username: String
    private let password: String
    
    init(
        username: String,
        password: String
        )
    {
        self.username = username
        self.password = password
    }
    
    let httpMethod: HTTPMethod = .post
    let isAuthorizationRequired = false
    let path = "api-token-auth"
    
    var params: [String: Any] {
        var parameters = [String: Any]()
        parameters["username"] = username
        parameters["password"] = password
        return parameters
    }
}
