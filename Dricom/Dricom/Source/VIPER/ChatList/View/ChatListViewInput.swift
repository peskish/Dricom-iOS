import Foundation

struct ChatListRowData {
    let avatarImage: String?
    let lastMessageUserName: String?
    let lastMessageText: String?
    let lastMessageCreatedAtText: String?
    
    let onTap: (() -> ())?
}

protocol ChatListViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    func setViewTitle(_ title: String)
    func setRowDataList(_ rowDataList: [ChatListRowData])
}
