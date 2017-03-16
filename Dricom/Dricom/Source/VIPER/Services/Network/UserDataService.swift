protocol UserDataService: class {
    func requestUserData(completion: ApiResult<Void>.Completion?)
    func subscribe(_ observer: AnyObject, onUserDataReceived: @escaping (User) -> ())
}

protocol UserDataNotifier: class {
    func notifyOnUserDataReceived(_ user: User)
}

private struct UserDataSubscriber {
    weak var object: AnyObject?
    let onUserDataReceived: (User) -> ()
}

final class UserDataServiceImpl: UserDataService, UserDataNotifier {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    
    // MARK: - Properties
    private var subscribers = [UserDataSubscriber]()
    
    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - UserDataService
    func requestUserData(completion: ApiResult<Void>.Completion?) {
        let request = AccountRequest()
        networkClient.send(request: request) { [weak self] result in
            result.onData { user in
                self?.notifyOnUserDataReceived(user)
                completion?(.data())
            }
            result.onError { networkRequestError in
                completion?(.error(networkRequestError))
            }
        }
    }
    
    func subscribe(_ observer: AnyObject, onUserDataReceived: @escaping (User) -> ()) {
        subscribers = subscribers.filter { $0.object !== observer && $0.object != nil }
        
        let subscriber = UserDataSubscriber(
            object: observer,
            onUserDataReceived: onUserDataReceived
        )
        
        subscribers.append(subscriber)
    }
    
    // MARK: - Private
    
    func notifyOnUserDataReceived(_ user: User) {
        self.allSubscribers().forEach { $0.onUserDataReceived(user) }
    }
    
    private func allSubscribers() -> [UserDataSubscriber] {
        subscribers = subscribers.filter { $0.object != nil }
        return subscribers
    }
}
