import Foundation

enum RegisterDataValidationResult {
    case correct
    case incorrect(errors: [RegisterInputFieldError])
}

struct RegisterInputFieldError {
    let field: RegisterInputField
    let errorType: RegisterDataValidationErrorType
}

enum RegisterDataValidationErrorType {
    case incorrectData(message: String)
    case requiredFieldIsEmpty
}

protocol RegisterDataValidationService {
    func validateData(_ data: RegisterData, completion: @escaping (RegisterDataValidationResult) -> ())
    func validateName(_ name: String?) -> RegisterInputFieldError?
    func validateEmail(_ email: String?) -> RegisterInputFieldError?
    func validateLicense(_ license: String?) -> RegisterInputFieldError?
    func validatePhone(_ phone: String?) -> RegisterInputFieldError?
    func validatePassword(_ password: String?) -> RegisterInputFieldError?
}

final class RegisterDataValidationServiceImpl: RegisterDataValidationService {
    func validateData(_ data: RegisterData, completion: @escaping (RegisterDataValidationResult) -> ()) {
        let errors: [RegisterInputFieldError] = [
            self.validateName(data.name),
            self.validateEmail(data.email),
            self.validateLicense(data.license),
            self.validatePhone(data.phone),
            self.validatePassword(data.password),
            self.validatePasswordConfirmation(data.passwordConfirmation, password: data.password)
            ].flatMap{$0}
        
        if errors.isEmpty {
            completion(.correct)
        } else {
            completion(.incorrect(errors: errors))
        }
    }
    
    func validateName(_ name: String?) -> RegisterInputFieldError? {
        guard let name = name, !name.isEmpty else {
            return RegisterInputFieldError(field: .name, errorType: .requiredFieldIsEmpty)
        }
        
        guard name.characters.count > 1 else {
            return RegisterInputFieldError(
                field: .name,
                errorType: .incorrectData(
                    message: "Имя: количество символов должно быть больше 1"
                )
            )
        }
        
        let nameRegexp = "^[а-яА-Яa-zA-Z ]+$"
        guard validate(text: name, regexp: nameRegexp) else {
            return RegisterInputFieldError(
                field: .name,
                errorType: .incorrectData(
                    message: "Имя может содержать только русские и латинские буквы и пробел"
                )
            )
        }
        
        return nil
    }
    
    func validateEmail(_ email: String?) -> RegisterInputFieldError? {
        guard let email = email, !email.isEmpty else {
            return RegisterInputFieldError(field: .email, errorType: .requiredFieldIsEmpty)
        }
        
        let emailRegexp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        guard validate(text: email, regexp: emailRegexp) else {
            return RegisterInputFieldError(
                field: .email,
                errorType: .incorrectData(
                    message: "Введите корректный адрес электронной почты"
                )
            )
        }
        
        return nil
    }
    
    func validateLicense(_ license: String?) -> RegisterInputFieldError? {
        guard let license = license, !license.isEmpty else {
            return RegisterInputFieldError(field: .license, errorType: .requiredFieldIsEmpty)
        }
        
        let licenseRegexp = "[A-Z][0-9]{3}[A-Z]{2}[0-9]{2,3}"
        guard validate(text: license, regexp: licenseRegexp) else {
            return RegisterInputFieldError(
                field: .license,
                errorType: .incorrectData(
                    message: "Введите корректный номер автомобиля"
                )
            )
        }
        
        return nil
    }
    
    func validatePhone(_ phone: String?) -> RegisterInputFieldError? {
        guard let phone = phone, !phone.isEmpty else {
            return RegisterInputFieldError(field: .phone, errorType: .requiredFieldIsEmpty)
        }
        
        let phoneRegexp = "^((8|\\+7)[\\- ]?)?(\\(?\\d{3}\\)?[\\- ]?)?[\\d\\- ]{7,10}$"
        guard validate(text: phone, regexp: phoneRegexp) else {
            return RegisterInputFieldError(
                field: .phone,
                errorType: .incorrectData(
                    message: "Введите корректный номер телефона"
                )
            )
        }
        
        return nil
    }
    
    func validatePassword(_ password: String?) -> RegisterInputFieldError? {
        guard let password = password, !password.isEmpty else {
            return RegisterInputFieldError(field: .password, errorType: .requiredFieldIsEmpty)
        }
        
        let passwordRegexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{6,}$"

        guard validate(text: password, regexp: passwordRegexp) else {
            return RegisterInputFieldError(
                field: .password,
                errorType: .incorrectData(
                    message: "Пароль должен быть не менее 6 символов длиной, содержать строчные и прописные латинские буквы и цифры"
                )
            )
        }
        
        
        
        return nil
    }
    
    private func validatePasswordConfirmation(
        _ passwordConfirmation: String?,
        password: String?
        ) -> RegisterInputFieldError?
    {
        guard let passwordConfirmation = passwordConfirmation, !passwordConfirmation.isEmpty else {
            return RegisterInputFieldError(field: .passwordConfirmation, errorType: .requiredFieldIsEmpty)
        }
        
        guard password == passwordConfirmation else {
            return RegisterInputFieldError(
                field: .passwordConfirmation,
                errorType: .incorrectData(
                    message: "Пароли должны совпадать"
                )
            )
        }
        
        return nil
    }
    
    private func validate(text: String, regexp: String) -> Bool {
        let testPredicate = NSPredicate(format: "SELF MATCHES %@", regexp)
        let string = text.replacingOccurrences(of: " ", with: "")
        
        return !isEmptyOrNil(string) && testPredicate.evaluate(with: string)
    }
}
