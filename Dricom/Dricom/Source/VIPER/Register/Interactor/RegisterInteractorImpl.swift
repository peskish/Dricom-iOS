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
    private let registrationService: RegistrationService
    private let registerDataValidationService: RegisterDataValidationService
    
    // MARK: - Init
    init(registerDataValidationService: RegisterDataValidationService, registrationService: RegistrationService) {
        self.registerDataValidationService = registerDataValidationService
        self.registrationService = registrationService
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
    
    func validateName() -> RegisterInputFieldError? {
        return registerDataValidationService.validateName(registerData.name)
    }
    
    func validateEmail() -> RegisterInputFieldError? {
        return registerDataValidationService.validateEmail(registerData.email)
    }
    
    func validateLicense() -> RegisterInputFieldError? {
        return registerDataValidationService.validateLicense(registerData.license)
    }
    
    func validatePhone() -> RegisterInputFieldError? {
        return registerDataValidationService.validatePhone(registerData.phone)
    }
    
    func validatePassword() -> RegisterInputFieldError? {
        return registerDataValidationService.validatePassword(registerData.password)
    }
    
    func registerUser(completion: @escaping (ApiResult<User>) -> ()) {
        let registrationData = RegistrationData(
            avatarImageId: nil, // TODO: after image uploading implementation
            name: registerData.name ?? "",
            email: registerData.email ?? "",
            phone: registerData.phone ?? "",
            license: registerData.license ?? "",
            password: registerData.password ?? "",
            token: nil // TODO: device token holder
        )
        registrationService.register(with: registrationData, completion: completion)
    }
}
