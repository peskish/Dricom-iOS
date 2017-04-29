protocol AuthorizationService: class {
    func authorize(username: String, password: String, completion: @escaping ApiResult<Void>.Completion)
}

import CryptoSwift

final class AuthorizationServiceImpl: AuthorizationService {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    private let loginResponseProcessor: LoginResponseProcessor
    private let userDataNotifier: UserDataNotifier
    private let dataValidationService: DataValidationService
    
    // MARK: - Init
    init(
        networkClient: NetworkClient,
        loginResponseProcessor: LoginResponseProcessor,
        userDataNotifier: UserDataNotifier,
        dataValidationService: DataValidationService)
    {
        self.networkClient = networkClient
        self.loginResponseProcessor = loginResponseProcessor
        self.userDataNotifier = userDataNotifier
        self.dataValidationService = dataValidationService
    }
    
    // MARK: - AuthorizationService
    func authorize(username: String, password: String, completion: @escaping ApiResult<Void>.Completion) {
        var username = username
        
        // Check if username is the license number
        if let license = LicenseNormalizer.normalize(license: username),
            dataValidationService.validateLicense(license) == nil {
            username = license
        }
        
        let request = AuthRequest(username: username, password: password.sha512())

        networkClient.send(request: request) { [weak self] result in
            result.onData { loginResponse in
                self?.loginResponseProcessor.processLoginResponse(loginResponse)
                self?.userDataNotifier.notifyOnUserDataReceived(loginResponse.user)
                completion(.data())
            }
            result.onError { networkRequestError in
                switch networkRequestError {
                case .badRequest:
                    // Treat 400 as 401 due to current backend implementation
                    completion(.error(NetworkRequestError.userIsNotAuthorized))
                default:
                    completion(.error(networkRequestError))
                }
            }
        }
    }
}
