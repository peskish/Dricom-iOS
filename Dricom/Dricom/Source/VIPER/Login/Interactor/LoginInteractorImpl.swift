import Foundation

final class LoginInteractorImpl: LoginInteractor {
    // MARK: Dependencies
    private let authorizationService: AuthorizationService
    
    // MARK: - Init
    init(authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
    }
    
    // MARK: - LoginInteractor
    func login(userName: String, password: String, completion: @escaping DataResult<Void, NetworkError>.Completion) {
        authorizationService.login(userName: userName, password: password, completion: completion)
    }
}
