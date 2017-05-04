import Alamofire

struct RegisterRequest: NetworkRequest {
    typealias Result = LoginResponse
    
    private let email: String
    private let name: String
    private let license: String
    private let phone: String
    private let password: String
    
    init(
        email: String,
        name: String,
        license: String,
        phone: String,
        password: String
        )
    {
        self.email = email
        self.name = name
        self.license = license
        self.phone = phone
        self.password = password
    }
    
    let httpMethod: HTTPMethod = .post
    let isAuthorizationRequired = false
    let path = "register"
    
    var params: [String: Any] {
        var parameters = [String: Any]()
        parameters["email"] = email
        parameters["first_name"] = name // TODO: return `name` back
        parameters["license"] = license
        parameters["phone"] = phone
        parameters["password"] = password
        return parameters
    }
}
