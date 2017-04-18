import Alamofire
import Unbox

struct AddUserToFavoritesRequest: NetworkRequest {
    typealias Result = AddUserToFavoritesResult
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    let httpMethod: HTTPMethod = .post
    let isAuthorizationRequired = true
    let path = "favorites"
    
    var params: [String: Any] {
        var parameters = [String: Any]()
        parameters["user_id"] = userId
        return parameters
    }
}

struct AddUserToFavoritesResult: Unboxable {
    let success: Bool
    
    init(unboxer: Unboxer) throws {
        let detail: String = try unboxer.unbox(key: "detail")
        success = detail == "added"
    }
}
