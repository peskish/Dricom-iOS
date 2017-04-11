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
    private let dataValidationService: DataValidationService
    
    // MARK: - Init
    init(dataValidationService: DataValidationService, registrationService: RegistrationService) {
        self.dataValidationService = dataValidationService
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
        registerData.license = LicenseNormalizer.normalize(license: license)
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
    
    func validateData(completion: @escaping (DataValidationResult) -> ()) {
        dataValidationService.validateData(registerData, completion: completion)
    }
    
    func validateName() -> InputFieldError? {
        return dataValidationService.validateName(registerData.name)
    }
    
    func validateEmail() -> InputFieldError? {
        return dataValidationService.validateEmail(registerData.email)
    }
    
    func validateLicense() -> InputFieldError? {
        return dataValidationService.validateLicense(registerData.license)
    }
    
    func validatePhone() -> InputFieldError? {
        return dataValidationService.validatePhone(registerData.phone)
    }
    
    func validatePassword() -> InputFieldError? {
        return dataValidationService.validatePassword(registerData.password)
    }
    
    func registerUser(completion: @escaping (ApiResult<Void>) -> ()) {
        let registrationData = RegistrationData(
            avatarImageDataCreator: { [weak self] in
                return self?.registerData.avatar.flatMap { return UIImageJPEGRepresentation($0, 0.9) }
            },
            name: registerData.name ?? "",
            email: registerData.email ?? "",
            phone: registerData.phone ?? "",
            license: registerData.license ?? "",
            password: registerData.password ?? ""
        )
        registrationService.register(with: registrationData, completion: completion)
    }
}
