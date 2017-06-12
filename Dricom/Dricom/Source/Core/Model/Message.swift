import Unbox
import JSQMessagesViewController

struct TextMessage: Unboxable {
    let id: String
    let createdAt: String
    let owner: User
    let text: String
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        createdAt = try unboxer.unbox(key: "created_at")
        owner = try unboxer.unbox(key: "owner")
        text = try unboxer.unbox(key: "text")
    }
}

extension TextMessage {
    func toJSQMessage() -> JSQMessage {
        return JSQMessage(
            senderId: owner.id,
            senderDisplayName: owner.name ?? "",
            date: createdAt.dateFromISO8601 ?? Date(),
            text: text
        )
    }
}
