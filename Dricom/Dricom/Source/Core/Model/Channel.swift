import Unbox

struct Channel: Unboxable {
    let id: String
    let updatedAt: String   // TODO: parse to date if needed
    let user: User
    let collocutor: User
    let lastMessage: TextMessage?
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        updatedAt = try unboxer.unbox(key: "updated_at")
        user = try unboxer.unbox(key: "user")
        collocutor = try unboxer.unbox(key: "collocutor")
        lastMessage = unboxer.unbox(key: "last_message")
    }
}
