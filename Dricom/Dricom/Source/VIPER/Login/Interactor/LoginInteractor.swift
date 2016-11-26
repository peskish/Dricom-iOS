import Foundation

protocol LoginInteractor: class {
    func login(userName: String, password: String, completion: @escaping ApiResult<Void>.Completion)
}
