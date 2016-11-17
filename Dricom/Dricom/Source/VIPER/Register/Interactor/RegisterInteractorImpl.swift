import UIKit

private struct RegisterData {
    var avatar: UIImage?
}

final class RegisterInteractorImpl: RegisterInteractor {
    // MARK: - State
    private var registerData = RegisterData()
    
    // MARK: - RegisterInteractor
    func setAvatar(_ avatar: UIImage) {
        registerData.avatar = avatar
    }
}
