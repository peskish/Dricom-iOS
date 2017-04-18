import Alamofire
import Unbox

struct RemoveUserFromFavoritesRequest: NetworkRequest {
    typealias Result = RemoveUserFromFavoritesResult
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    let httpMethod: HTTPMethod = .delete
    let isAuthorizationRequired = true
    var path: String {
        return "favorites/" + userId
    }
    
    var params = [String: Any]()
}

struct RemoveUserFromFavoritesResult: Unboxable {
    let success: Bool
    
    init(unboxer: Unboxer) throws {
        let detail: String = try unboxer.unbox(key: "detail")
        success = detail == "deleted"
    }
}
