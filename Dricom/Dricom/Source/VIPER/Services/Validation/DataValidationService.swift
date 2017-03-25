import Foundation

enum DataValidationResult {
    case correct
    case incorrect(errors: [InputFieldError])
}

protocol DataValidationService {
    func validateData(_ data: RegisterData, completion: @escaping (DataValidationResult) -> ())
    func validateName(_ name: String?) -> InputFieldError?
    func validateEmail(_ email: String?) -> InputFieldError?
    func validateLicense(_ license: String?) -> InputFieldError?
    func validatePhone(_ phone: String?) -> InputFieldError?
    func validatePassword(_ password: String?) -> InputFieldError?
}

final class DataValidationServiceImpl: DataValidationService {
    func validateData(_ data: RegisterData, completion: @escaping (DataValidationResult) -> ()) {
        let validator = InputFieldValidator()
        
        let errors: [InputFieldError] = [
            validator.validateName(data.name),
            validator.validateEmail(data.email),
            validator.validateLicense(data.license),
            validator.validatePhone(data.phone),
            validator.validatePassword(data.password),
            validator.validatePasswordConfirmation(data.passwordConfirmation, password: data.password)
            ].flatMap{$0}
        
        if errors.isEmpty {
            completion(.correct)
        } else {
            completion(.incorrect(errors: errors))
        }
    }
    
    func validateName(_ name: String?) -> InputFieldError? {
        return InputFieldValidator().validateName(name)
    }
    
    func validateEmail(_ email: String?) -> InputFieldError? {
        return InputFieldValidator().validateEmail(email)
    }
    
    func validateLicense(_ license: String?) -> InputFieldError? {
        return InputFieldValidator().validateLicense(license)
    }
    
    func validatePhone(_ phone: String?) -> InputFieldError? {
        return InputFieldValidator().validatePhone(phone)
    }
    
    func validatePassword(_ password: String?) -> InputFieldError? {
        return InputFieldValidator().validatePassword(password)
    }
}
