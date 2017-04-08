import Foundation

protocol LoginInteractor: class {
    func login(username: String, password: String, completion: @escaping ApiResult<Void>.Completion)
}
