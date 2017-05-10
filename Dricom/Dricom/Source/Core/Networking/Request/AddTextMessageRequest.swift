import Alamofire
import Unbox

struct AddTextMessageRequest: NetworkRequest {
    typealias Result = AddTextMessageResult
    
    private let channelId: String
    private let text: String
    
    init(channelId: String, text: String) {
        self.channelId = channelId
        self.text = text
    }
    
    let httpMethod: HTTPMethod = .post
    let isAuthorizationRequired = true
    var path: String {
        return "channels/\(channelId)/messages"
    }
    
    var params: [String: Any] {
        var parameters = [String: Any]()
        parameters["text"] = text
        return parameters
    }
}

struct AddTextMessageResult: Unboxable {
    let success: Bool
    
    init(unboxer: Unboxer) throws {
        let detail: String = try unboxer.unbox(key: "detail")
        success = detail == "ok"
    }
}
