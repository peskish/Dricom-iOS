import Foundation

protocol MainPageInteractor: class {
    func searchUser(license: String, completion: @escaping ApiResult<User?>.Completion)
    var onUserDataReceived: ((User) -> ())? { get set }
}
