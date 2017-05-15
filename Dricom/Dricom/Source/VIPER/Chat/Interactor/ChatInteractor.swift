import Foundation

protocol ChatInteractor: class {
    func obtainChannel() -> Channel
    func messages(completion: @escaping ApiResult<[TextMessage]>.Completion)
}
