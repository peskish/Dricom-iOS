import Foundation

final class LoginInteractorImpl: LoginInteractor {
    // MARK: Dependencies
    private let authorizationService: AuthorizationService
    
    // MARK: - Init
    init(authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
    }
    
    // MARK: - LoginInteractor
    func login(email: String, password: String, completion: @escaping ApiResult<User>.Completion) {
        authorizationService.authorize(email: email, password: password, completion: completion)
    }
}
