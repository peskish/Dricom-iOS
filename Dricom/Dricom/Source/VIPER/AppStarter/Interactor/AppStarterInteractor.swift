import Foundation

protocol AppStarterInteractor: class {
    func user(completion: @escaping ApiResult<User>.Completion)
}
