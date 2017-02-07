import Alamofire

final class RegisterRequest: NetworkRequest {
    typealias Result = LoginResponse
    
    private let email: String
    private let name: String
    private let license: String
    private let phone: String
    private let password: String
    private let token: String?
    
    init(
        email: String,
        name: String,
        license: String,
        phone: String,
        password: String,
        token: String?
        )
    {
        self.email = email
        self.name = name
        self.license = license
        self.phone = phone
        self.password = password
        self.token = token
    }
    
    let version = 1
    let httpMethod: HTTPMethod = .post
    let isAuthorizationRequired = false
    let path = "register"
    
    var params: [String: Any] {
        var parameters = [String: Any]()
        parameters["email"] = email
        parameters["name"] = name
        parameters["license"] = license
        parameters["phone"] = phone
        parameters["password"] = password
        parameters["token"] = token
        return parameters
    }
}
