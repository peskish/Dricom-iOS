import Alamofire
import Unbox

struct ChannelMessagesRequest: NetworkRequest {
    typealias Result = ChannelMessagesResult
    
    private let channelId: String
    
    init(channelId: String) {
        self.channelId = channelId
    }
    
    let httpMethod: HTTPMethod = .get
    let isAuthorizationRequired = true
    var path: String {
        return "channels/\(channelId)/messages"
    }
    
    let params: [String: Any] = [:]
}

struct ChannelMessagesResult: Unboxable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [TextMessage]
    
    init(unboxer: Unboxer) throws {
        count = try unboxer.unbox(key: "count")
        next = try? unboxer.unbox(key: "next")
        previous = try? unboxer.unbox(key: "previous")
        results = unboxer.unbox(key: "results", fallbackValue: [])
    }
}
