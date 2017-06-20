import Foundation

final class ChatListInteractorImpl: ChatListInteractor {
    // MARK: - Dependencies
    private let userDataObservable: UserDataObservable
    private let messengerService: MessengerService
    
    // MARK: - Init
    init(userDataObservable: UserDataObservable, messengerService: MessengerService) {
        self.userDataObservable = userDataObservable
        self.messengerService = messengerService
        
        self.userDataObservable.subscribe(self) { [weak self] user in
            self?.onAccountDataReceived?(user)
        }
    }
    
    // MARK: - ChatListInteractor
    func chatList(completion: @escaping ApiResult<[Channel]>.Completion) {
        messengerService.chatList { result in
            result.onData { chatListResult in
                completion(.data(chatListResult.results))
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
    
    var onAccountDataReceived: ((User) -> ())?
}
