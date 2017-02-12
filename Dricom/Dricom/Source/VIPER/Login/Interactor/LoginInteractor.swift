import Foundation

protocol LoginInteractor: class {
    func login(email: String, password: String, completion: @escaping ApiResult<User>.Completion)
}
