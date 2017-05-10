import Alamofire
import Unbox

struct ChannelsRequest: NetworkRequest {
    typealias Result = ChannelsResult
    
    let httpMethod: HTTPMethod = .get
    let isAuthorizationRequired = true
    let path = "channels"
    let params = [String: Any]()
}

struct ChannelsResult: Unboxable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Channel]
    
    init(unboxer: Unboxer) throws {
        count = try unboxer.unbox(key: "count")
        next = try? unboxer.unbox(key: "next")
        previous = try? unboxer.unbox(key: "previous")
        results = unboxer.unbox(key: "results", fallbackValue: [])
    }
}
