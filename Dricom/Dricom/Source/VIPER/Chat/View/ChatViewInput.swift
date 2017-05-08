import Foundation
import JSQMessagesViewController

protocol ChatViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    func setMessages(_ messages: [JSQMessage])
}
