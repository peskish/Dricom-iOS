struct RegistrationData {
    var avatarImageId: String?
    var name: String
    var email: String
    var phone: String
    var license: String
    var password: String
    let token: String?
}

protocol RegistrationService {
    func register(with data: RegistrationData, completion: @escaping ApiResult<Void>.Completion)
}

final class RegistrationServiceImpl: RegistrationService {
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
    
    // MARK: - RegistrationService
    func register(with data: RegistrationData, completion: @escaping ApiResult<Void>.Completion) {
        let request = RegisterRequest(
            email: data.email,
            name: data.name,
            license: data.license,
            phone: data.phone,
            password: data.password,
            token: nil  // TODO: send push token if exists
        )
        
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
