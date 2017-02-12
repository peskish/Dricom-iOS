protocol AuthorizationService: class {
    func authorize(email: String, password: String, completion: @escaping ApiResult<User>.Completion)
}

import CryptoSwift

final class AuthorizationServiceImpl: AuthorizationService {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    
    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - AuthorizationService
    func authorize(email: String, password: String, completion: @escaping ApiResult<User>.Completion) {
        let request = AuthRequest(email: email, password: password.sha512())

        networkClient.send(request: request) { result in
            result.onData { [weak self] loginResponse in
                self?.networkClient.jwt = loginResponse.jwt
                completion(.data(loginResponse.user))
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
}
