final class RegistrationServiceImpl: RegistrationService {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    
    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
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
        
        networkClient.send(request: request) { result in
            result.onData { [weak self] loginResponse in
                self?.networkClient.jwt = loginResponse.jwt
                completion(.data())
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
}
