import Foundation

struct RegistrationData {
    var avatarImageDataCreator: (() -> Data?)?
    var name: String
    var email: String
    var phone: String
    var license: String
    var password: String
}

protocol RegistrationService {
    func register(with registrationData: RegistrationData, completion: @escaping ApiResult<Void>.Completion)
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
    func register(with registrationData: RegistrationData, completion: @escaping ApiResult<Void>.Completion) {
        let request = RegisterRequest(
            email: registrationData.email,
            name: registrationData.name,
            license: registrationData.license,
            phone: registrationData.phone,
            password: registrationData.password
        )
        
        networkClient.send(request: request) { [weak self] result in
            result.onData { loginResponse in
                self?.loginResponseProcessor.processLoginResponse(loginResponse)
                
                if let avatarImageDataCreator = registrationData.avatarImageDataCreator {
                    DispatchQueue.global().async {
                        if let avatarImageData = avatarImageDataCreator() {
                            let uploadAvatarRequest = UploadAvatarRequest(imageData: avatarImageData)
                            _ = self?.networkClient.send(request: uploadAvatarRequest) { uploadAvatarResult in
                                // No matter success or failure - user was registered already
                                uploadAvatarResult.onData { avatarLoginResponse in
                                    self?.processLoginResponse(avatarLoginResponse, completion: completion)
                                }
                                uploadAvatarResult.onError { avatarError in
                                    debugPrint(avatarError)
                                    self?.processLoginResponse(loginResponse, completion: completion)
                                }
                            }
                        } else {
                            self?.processLoginResponse(loginResponse, completion: completion)
                        }
                    }
                } else {
                    self?.processLoginResponse(loginResponse, completion: completion)
                }
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
    
    private func processLoginResponse(
        _ loginResponse: LoginResponse,
        completion: @escaping ApiResult<Void>.Completion)
    {
        DispatchQueue.main.async {
            self.userDataNotifier.notifyOnUserDataReceived(loginResponse.user)
            completion(.data())
        }
    }
}
