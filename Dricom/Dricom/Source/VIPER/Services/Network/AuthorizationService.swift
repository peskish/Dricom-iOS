protocol AuthorizationService: class {
    func authorize(email: String, password: String, completion: @escaping ApiResult<Void>.Completion)
}

import CryptoSwift

final class AuthorizationServiceImpl: AuthorizationService {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    private let loginResponseProcessor: LoginResponseProcessor
    private let userDataNotifier: UserDataNotifier
    
    // MARK: - Init
    init(
        networkClient: NetworkClient,
        loginResponseProcessor: LoginResponseProcessor,
        userDataNotifier: UserDataNotifier)
    {
        self.networkClient = networkClient
        self.loginResponseProcessor = loginResponseProcessor
        self.userDataNotifier = userDataNotifier
    }
    
    // MARK: - AuthorizationService
    func authorize(email: String, password: String, completion: @escaping ApiResult<Void>.Completion) {
        let request = AuthRequest(email: email, password: password.sha512())

        networkClient.send(request: request) { [weak self] result in
            result.onData { loginResponse in
                self?.loginResponseProcessor.processLoginResponse(loginResponse)
                self?.userDataNotifier.notifyOnUserDataReceived(loginResponse.user)
                completion(.data())
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
}
