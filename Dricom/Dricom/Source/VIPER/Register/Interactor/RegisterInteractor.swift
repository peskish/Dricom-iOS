import UIKit

protocol RegisterInteractor: class {
    func hasAvatar() -> Bool
    
    func setAvatar(_ avatar: UIImage?)
    func setName(_ name: String?)
    func setEmail(_ email: String?)
    func setLicense(_ license: String?)
    func setPhone(_ phone: String?)
    func setPassword(_ password: String?)
    func setPasswordConfirmation(_ passwordConfirmation: String?)
    
    func validateData(completion: @escaping (DataValidationResult) -> ())
    func validateName() -> InputFieldError?
    func validateEmail() -> InputFieldError?
    func validateLicense() -> InputFieldError?
    func validatePhone() -> InputFieldError?
    func validatePassword() -> InputFieldError?
    
    func registerUser(completion: @escaping ApiResult<Void>.Completion)
}
