enum ApplicationTab: Int {
    case mainPage
    case chatList
    case mapEvents
    case account
    
    static var tabs: [ApplicationTab] {
        return [.mainPage, .chatList, .mapEvents, .account]
    }
}

protocol ApplicationViewInput: class, DisposeBagHolder {
    func selectTab(_ tab: ApplicationTab)
}
