import UIKit

struct RegisterData {
    var avatar: UIImage?
    var name: String?
    var email: String?
    var phone: String?
    var license: String?
    var password: String?
    var passwordConfirmation: String?
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
    
    func setName(_ name: String?) {
        registerData.name = name
    }
    
    func setEmail(_ email: String?) {
        registerData.email = email
    }
    
    func setLicense(_ license: String?) {
        registerData.license = license
    }
    
    func setPhone(_ phone: String?) {
        registerData.phone = phone
    }
    
    func setPassword(_ password: String?) {
        registerData.password = password
    }
    
    func setPasswordConfirmation(_ passwordConfirmation: String?) {
        registerData.passwordConfirmation = passwordConfirmation
    }
}
