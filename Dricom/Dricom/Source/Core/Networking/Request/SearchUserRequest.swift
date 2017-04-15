import Alamofire
import Unbox

struct SearchUserRequest: NetworkRequest {
    typealias Result = SearchUserResult
    
    private let license: String
    
    init(license: String) {
        self.license = license
    }
    
    let httpMethod: HTTPMethod = .get
    let isAuthorizationRequired = true
    let path = "search"
    let encoding: ParameterEncoding = URLEncoding.default
    
    var params: [String: Any] {
        var parameters = [String: Any]()
        parameters["license"] = license
        return parameters
    }
}

struct SearchUserResult: Unboxable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [User]
    
    init(unboxer: Unboxer) throws {
        count = try unboxer.unbox(key: "count")
        next = try? unboxer.unbox(key: "next")
        previous = try? unboxer.unbox(key: "previous")
        results = unboxer.unbox(key: "results", fallbackValue: [])
    }
}
