import Foundation

final class ChangePasswordInteractorImpl: ChangePasswordInteractor {
    // MARK: - ChangePasswordInteractor
    func setOldPassword(_ oldPassword: String?) {
        
    }
    
    func setPassword(_ password: String?) {
        
    }
    
    func setPasswordConfirmation(_ passwordConfirmation: String?) {
        
    }
    
    func validateData(completion: @escaping (DataValidationResult) -> ()) {
        
    }
    
    func validateOldPassword() -> InputFieldError? {
        return nil
    }
    
    func validatePassword() -> InputFieldError? {
        return nil
    }
    
    func validatePasswordConfirmation() -> InputFieldError? {
        return nil
    }
    
    func changePassword(completion: @escaping ApiResult<Void>.Completion) {
        
    }
}
