import Alamofire
import Unbox

struct CreateChannelRequest: NetworkRequest {
    typealias Result = Channel
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    let httpMethod: HTTPMethod = .post
    let isAuthorizationRequired = true
    let path = "channels"
    
    var params: [String: Any] {
        var parameters = [String: Any]()
        parameters["user_id"] = userId
        return parameters
    }
}
