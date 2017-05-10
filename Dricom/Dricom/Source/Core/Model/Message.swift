import Unbox

struct TextMessage: Unboxable {
    let id: String
    let createdAt: String   // TODO: parse to date if needed
    let owner: User
    let text: String
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        createdAt = try unboxer.unbox(key: "created_at")
        owner = try unboxer.unbox(key: "owner")
        text = try unboxer.unbox(key: "text")
    }
}
