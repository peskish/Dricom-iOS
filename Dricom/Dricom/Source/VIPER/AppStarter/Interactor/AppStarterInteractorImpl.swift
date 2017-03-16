import Foundation

final class AppStarterInteractorImpl: AppStarterInteractor {
    // MARK: Dependencies
    private let userDataService: UserDataService
    
    // MARK: - Init
    init(userDataService: UserDataService) {
        self.userDataService = userDataService
    }
    
    // MARK: - AppStarterInteractor
    func requestUserData(completion: ApiResult<Void>.Completion?) {
        userDataService.requestUserData(completion: completion)
    }
}
