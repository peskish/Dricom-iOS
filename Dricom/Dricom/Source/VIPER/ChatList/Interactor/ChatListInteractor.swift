import Foundation

protocol ChatListInteractor: class {
    func chatList(completion: @escaping ApiResult<[Channel]>.Completion)
    
    var onAccountDataReceived: ((User) -> ())? { get set }
}
