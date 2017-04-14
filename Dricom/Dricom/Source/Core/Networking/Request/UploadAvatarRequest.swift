import Alamofire

struct UploadAvatarRequest: MultipartFormDataRequest {
    typealias Result = LoginResponse
    
    private let imageData: Data
    
    init(imageData: Data) {
        self.imageData = imageData
    }
    
    let isAuthorizationRequired = true
    let path = "upload-avatar"
    let params: [String: Any] = [:]
    let httpMethod: HTTPMethod = .post
    
    var uploadData: Data? {
        return imageData
    }
    
    let name = "image"
    let fileName = "avatar.jpg"
    let mimeType = "image/jpg"
}
