import Foundation
import JSQMessagesViewController

struct ChannelInfo {
    let collocutorName: String
    let ownerId: String
    let ownerName: String
}

protocol ChatViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    func setChannelInfo(_ info: ChannelInfo)
    func setMessages(_ messages: [JSQMessage])
    var onTapSendButton: ((_ text: String) -> ())? { get set }
}
