protocol AuthorizationService: class {
    func authorize(email: String, password: String, completion: @escaping ApiResult<User>.Completion)
}

import CryptoSwift

final class AuthorizationServiceImpl: AuthorizationService {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    private let loginResponseProcessor: LoginResponseProcessor
    
    // MARK: - Init
    init(networkClient: NetworkClient, loginResponseProcessor: LoginResponseProcessor) {
        self.networkClient = networkClient
        self.loginResponseProcessor = loginResponseProcessor
    }
    
    // MARK: - AuthorizationService
    func authorize(email: String, password: String, completion: @escaping ApiResult<User>.Completion) {
        let request = AuthRequest(email: email, password: password.sha512())

        networkClient.send(request: request) { result in
            result.onData { [weak self] loginResponse in
                self?.loginResponseProcessor.processLoginResponse(loginResponse)
                completion(.data(loginResponse.user))
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
}
