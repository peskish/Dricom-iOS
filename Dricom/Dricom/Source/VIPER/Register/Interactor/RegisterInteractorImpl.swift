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
    
    // MARK: - Dependencies
    private let registerDataValidationService: RegisterDataValidationService
    
    // MARK: - Init
    init(registerDataValidationService: RegisterDataValidationService) {
        self.registerDataValidationService = registerDataValidationService
    }
    
    // MARK: - RegisterInteractor
    func hasAvatar() -> Bool {
        return registerData.avatar != nil
    }
    
    func setAvatar(_ avatar: UIImage?) {
        registerData.avatar = avatar
    }
    
    func setName(_ name: String?) {
        registerData.name = name?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setEmail(_ email: String?) {
        registerData.email = email?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setLicense(_ license: String?) {
        registerData.license = license?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setPhone(_ phone: String?) {
        registerData.phone = phone?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setPassword(_ password: String?) {
        registerData.password = password?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setPasswordConfirmation(_ passwordConfirmation: String?) {
        registerData.passwordConfirmation = passwordConfirmation?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func validateData(completion: @escaping (RegisterDataValidationResult) -> ()) {
        registerDataValidationService.validateData(registerData, completion: completion)
    }
    
    func registerUser(completion: (DataResult<Void, NetworkError>) -> ()) {
        // TODO: Call service and proceed
    }
}
