import Foundation

final class LoginInteractorImpl: LoginInteractor {
    // MARK: Dependencies
    private let authorizationService: AuthorizationService
    
    // MARK: - Init
    init(authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
    }
    
    // MARK: - LoginInteractor
    func login(username: String, password: String, completion: @escaping ApiResult<Void>.Completion) {
        authorizationService.authorize(username: username, password: password, completion: completion)
    }
}
