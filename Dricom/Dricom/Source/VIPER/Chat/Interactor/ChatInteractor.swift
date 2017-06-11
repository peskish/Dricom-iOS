import Foundation

protocol ChatInteractor: class {
    func obtainChannel() -> Channel
    
    func startMessagesPolling()
    
    func fetchMessages(completion: @escaping ApiResult<[TextMessage]>.Completion)
    
    func send(_ text: String, completion: @escaping ApiResult<[TextMessage]>.Completion)
    
    var onReceiveMessages: (([TextMessage]) -> ())? { get set }
}
