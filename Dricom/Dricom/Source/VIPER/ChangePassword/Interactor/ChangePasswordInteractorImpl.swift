import Foundation

struct PasswordChangeData {
    var oldPassword: String?
    var password: String?
    var passwordConfirmation: String?
}

final class ChangePasswordInteractorImpl: ChangePasswordInteractor {
    // MARK: - Dependencies
    private let userDataService: UserDataService
    private let dataValidationService: DataValidationService
    
    // MARK: - State
    private var passwordChangeData = PasswordChangeData()
    
    // MARK: - Init
    init(userDataService: UserDataService, dataValidationService: DataValidationService) {
        self.userDataService = userDataService
        self.dataValidationService = dataValidationService
    }
    
    // MARK: - ChangePasswordInteractor
    func setOldPassword(_ oldPassword: String?) {
        passwordChangeData.oldPassword = oldPassword
    }
    
    func setPassword(_ password: String?) {
        passwordChangeData.password = password
    }
    
    func setPasswordConfirmation(_ passwordConfirmation: String?) {
        passwordChangeData.passwordConfirmation = passwordConfirmation
    }
    
    func validateData(completion: @escaping (DataValidationResult) -> ()) {
        dataValidationService.validateData(passwordChangeData, completion: completion)
    }
    
    func validateOldPassword() -> InputFieldError? {
        return dataValidationService.validateOldPassword(passwordChangeData.oldPassword)
    }
    
    func validatePassword() -> InputFieldError? {
        return dataValidationService.validatePassword(passwordChangeData.password)
    }
    
    func changePassword(completion: @escaping ApiResult<Bool>.Completion) {
        guard let oldPassword = passwordChangeData.oldPassword,
            let newPassword = passwordChangeData.password else
        {
            completion(.error(.wrongInputParameters(message: "Проверьте введенные данные")))
            return
        }
        
        userDataService.changePassword(oldPassword: oldPassword, newPassword: newPassword, completion: completion)
    }
}
