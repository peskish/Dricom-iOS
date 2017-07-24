import Foundation

struct ChatListRowData {
    let avatarImageUrl: URL?
    let userName: String?
    let messageText: String?
    let createdAtText: String?
    
    let onTap: (() -> ())?
}

struct ChatListEmptyRowData {
    let title: String
    let message: String
}

enum ChatListViewState {
    case undefined
    case empty(ChatListEmptyRowData)
    case data([ChatListRowData])
}

protocol ChatListViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    func setViewTitle(_ title: String)
    func setState(_ state: ChatListViewState)
}
