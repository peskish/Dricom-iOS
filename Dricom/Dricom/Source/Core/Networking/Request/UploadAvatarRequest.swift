import Alamofire

struct UploadAvatarRequest: NetworkRequest {
    typealias Result = SuccessResponse
    
    private let imageData: Data
    
    init(imageData: Data) {
        self.imageData = imageData
    }
    
    let httpMethod: HTTPMethod = .post
    let isAuthorizationRequired = true
    let path = "upload-avatar"
    
    var uploadData: Data? {
        return imageData
    }
    
    let params = [String: Any]()
}
