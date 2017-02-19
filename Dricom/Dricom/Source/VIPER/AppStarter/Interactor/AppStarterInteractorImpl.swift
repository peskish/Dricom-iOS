import Foundation

final class AppStarterInteractorImpl: AppStarterInteractor {
    // MARK: Dependencies
    private let userDataService: UserDataService
    
    // MARK: - Init
    init(userDataService: UserDataService) {
        self.userDataService = userDataService
    }
    
    // MARK: - AppStarterInteractor
    func user(completion: @escaping ApiResult<User>.Completion) {
        userDataService.user(completion: completion)
    }
}
