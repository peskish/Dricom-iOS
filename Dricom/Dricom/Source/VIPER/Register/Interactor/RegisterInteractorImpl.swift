import UIKit

private struct RegisterData {
    var avatar: UIImage?
}

final class RegisterInteractorImpl: RegisterInteractor {
    // MARK: - State
    private var registerData = RegisterData()
    
    // MARK: - RegisterInteractor
    func hasAvatar() -> Bool {
        return registerData.avatar != nil
    }
    
    func setAvatar(_ avatar: UIImage?) {
        registerData.avatar = avatar
    }
}
