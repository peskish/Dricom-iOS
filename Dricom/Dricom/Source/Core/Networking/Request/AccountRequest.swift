import Alamofire

struct AccountRequest: NetworkRequest {
    typealias Result = User
    
    let httpMethod: HTTPMethod = .get
    let isAuthorizationRequired = true
    let path = "account"
    
    var params = [String: Any]()
}
