import Foundation

protocol ChatInteractor: class {
    func obtainChannel() -> Channel
    func messages(completion: @escaping ApiResult<[TextMessage]>.Completion)
    func send(_ text: String, completion: @escaping ApiResult<[TextMessage]>.Completion)
}
