import Foundation

protocol MainPageInteractor: class {
    func searchUser(license: String, completion: @escaping ApiResult<UserInfo?>.Completion)
    var onAccountDataReceived: ((User) -> ())? { get set }
}
