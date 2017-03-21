import Foundation

protocol UserProfileInteractor: class {
    func requestUserData(completion: ApiResult<Void>.Completion?)
    var onUserDataReceived: ((User) -> ())? { get set }
}
