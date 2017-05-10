import Alamofire
import Unbox

struct CreateChannelRequest: NetworkRequest {
    typealias Result = CreateChannelResult
    
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

struct CreateChannelResult: Unboxable {
    let id: String
    let updatedAt: String
    let user: User
    let collocutor: User
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        updatedAt = try unboxer.unbox(key: "updated_at")
        user = try unboxer.unbox(key: "user")
        collocutor = try unboxer.unbox(key: "collocutor")
    }
}
