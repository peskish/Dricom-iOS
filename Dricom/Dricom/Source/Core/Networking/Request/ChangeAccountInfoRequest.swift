import Alamofire

struct ChangeAccountInfoRequest: NetworkRequest {
    typealias Result = LoginResponse
    
    private let email: String?
    private let name: String?
    private let phone: String?
    
    init(
        email: String?,
        name: String?,
        phone: String?
        )
    {
        self.email = email
        self.name = name
        self.phone = phone
    }
    
    let httpMethod: HTTPMethod = .post
    let isAuthorizationRequired = true
    let path = "account"
    
    var params: [String: Any] {
        var parameters = [String: Any]()
        parameters["email"] = email
        parameters["first_name"] = name // TODO: return `name` back
        parameters["phone"] = phone
        return parameters
    }
}
