import Alamofire
import Unbox

struct FavoriteUsersRequest: NetworkRequest {
    typealias Result = SearchUserResult
    
    let httpMethod: HTTPMethod = .get
    let isAuthorizationRequired = true
    let path = "favorites"
    let params = [String: Any]()
}
