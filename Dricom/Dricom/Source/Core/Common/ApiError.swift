import Unbox

struct ApiError: Unboxable {
    let code: Int
    let message: String?
    
    init(code: Int, message: String?) {
        self.code = code
        self.message = message
    }
    
    //MARK: - Unboxable
    public init(unboxer: Unboxer) throws {
        code = try unboxer.unbox(key: "code")
        message = unboxer.unbox(key: "message")
    }
}
