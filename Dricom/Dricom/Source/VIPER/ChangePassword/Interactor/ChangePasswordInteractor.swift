import Foundation

protocol ChangePasswordInteractor: class {
    func setOldPassword(_ oldPassword: String?)
    func setPassword(_ password: String?)
    func setPasswordConfirmation(_ passwordConfirmation: String?)
    
    func validateData(completion: @escaping (DataValidationResult) -> ())
    
    func validateOldPassword() -> InputFieldError?
    func validatePassword() -> InputFieldError?
    
    func changePassword(completion: @escaping ApiResult<Bool>.Completion)
}
