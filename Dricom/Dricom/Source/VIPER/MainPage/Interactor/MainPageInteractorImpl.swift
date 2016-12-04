import Foundation

final class MainPageInteractorImpl: MainPageInteractor {
    // MARK: Properties
    private var user: User
    
    // MARK: Init
    init(user: User) {
        self.user = user
    }
    
    // MARK: - MainPageInteractor
    func user(completion: (User) -> ()) {
        completion(user)
    }
}
