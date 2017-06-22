import Foundation

struct ChatListRowData {
    let avatarImageUrl: URL?
    let userName: String?
    let messageText: String?
    let createdAtText: String?
    
    let onTap: (() -> ())?
}

protocol ChatListViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    func setViewTitle(_ title: String)
    func setRowDataList(_ rowDataList: [ChatListRowData])
}
