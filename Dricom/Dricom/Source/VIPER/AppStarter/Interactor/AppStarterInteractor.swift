import Foundation

protocol AppStarterInteractor: class {
    func requestUserData(completion: ApiResult<Void>.Completion?)
}
