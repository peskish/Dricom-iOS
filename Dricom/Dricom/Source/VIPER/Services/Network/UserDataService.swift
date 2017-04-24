import UIKit

struct UserProfileDataChangeSet {
    var avatar: UIImage?
    var name: String?
    var email: String?
    var phone: String?
    
    var hasFieldChanges: Bool {
        return name != nil || email != nil || phone != nil
    }
}

protocol UserDataService: class {
    func requestUserData(completion: ApiResult<Void>.Completion?)
    func changeUserData(with changeSet: UserProfileDataChangeSet, completion: @escaping ApiResult<Void>.Completion)
    func changeUserAvatar(_ avatar: UIImage, completion: @escaping ApiResult<Void>.Completion)
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
    private let loginResponseProcessor: LoginResponseProcessor
    
    // MARK: - Properties
    private var subscribers = [UserDataSubscriber]()
    
    // MARK: - Init
    init(networkClient: NetworkClient, loginResponseProcessor: LoginResponseProcessor) {
        self.networkClient = networkClient
        self.loginResponseProcessor = loginResponseProcessor
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
    
    func changeUserData(with changeSet: UserProfileDataChangeSet, completion: @escaping ApiResult<Void>.Completion) {
        if changeSet.hasFieldChanges {
            let request = ChangeAccountInfoRequest(
                email: changeSet.email,
                name: changeSet.name,
                phone: changeSet.phone
            )
            
            networkClient.send(request: request) { [weak self] result in
                result.onData { loginResponse in
                    self?.loginResponseProcessor.processLoginResponse(loginResponse)
                    
                    if let avatar = changeSet.avatar {
                        self?.changeUserAvatar(avatar, completion: completion)
                    }
                }
                result.onError { networkRequestError in
                    completion(.error(networkRequestError))
                }
            }
        }
    }

    func changeUserAvatar(_ avatar: UIImage, completion: @escaping ApiResult<Void>.Completion) {
        DispatchQueue.global().async {
            if let avatarImageData = UIImageJPEGRepresentation(avatar, 0.9) {
                let uploadAvatarRequest = UploadAvatarRequest(imageData: avatarImageData)
                self.networkClient.send(request: uploadAvatarRequest) { uploadAvatarResult in
                    uploadAvatarResult.onData { [weak self] avatarLoginResponse in
                        self?.processLoginResponse(avatarLoginResponse, completion: completion)
                    }
                    uploadAvatarResult.onError { avatarError in
                        debugPrint(avatarError)
                    }
                }
            }
        }
    }

    // MARK: - Private
    private func processLoginResponse(
        _ loginResponse: LoginResponse,
        completion: @escaping ApiResult<Void>.Completion)
    {
        DispatchQueue.main.async {
            self.notifyOnUserDataReceived(loginResponse.user)
            completion(.data())
        }
    }
    
    func notifyOnUserDataReceived(_ user: User) {
        self.allSubscribers().forEach { $0.onUserDataReceived(user) }
    }
    
    private func allSubscribers() -> [UserDataSubscriber] {
        subscribers = subscribers.filter { $0.object != nil }
        return subscribers
    }
}
