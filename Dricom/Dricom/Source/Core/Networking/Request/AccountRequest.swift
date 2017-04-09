import Alamofire

struct AccountRequest: NetworkRequest {
    typealias Result = User
    
    let version = 1
    let httpMethod: HTTPMethod = .get
    let isAuthorizationRequired = true
    let path = "account"
    
    var params = [String: Any]()
}
