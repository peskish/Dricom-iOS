import Foundation

final class InputFieldValidator {
    func validateName(_ name: String?) -> InputFieldError? {
        guard let name = name, !name.isEmpty else {
            return InputFieldError(field: .name, errorType: .requiredFieldIsEmpty)
        }
        
        guard name.characters.count > 1 else {
            return InputFieldError(
                field: .name,
                errorType: .incorrectData(
                    message: "Имя: количество символов должно быть больше 1"
                )
            )
        }
        
        let nameRegexp = "^[а-яА-Яa-zA-Z ]+$"
        guard validate(text: name, regexp: nameRegexp) else {
            return InputFieldError(
                field: .name,
                errorType: .incorrectData(
                    message: "Имя может содержать только русские и латинские буквы и пробел"
                )
            )
        }
        
        return nil
    }
    
    func validateEmail(_ email: String?) -> InputFieldError? {
        guard let email = email, !email.isEmpty else {
            return InputFieldError(field: .email, errorType: .requiredFieldIsEmpty)
        }
        
        let emailRegexp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        guard validate(text: email, regexp: emailRegexp) else {
            return InputFieldError(
                field: .email,
                errorType: .incorrectData(
                    message: "Введите корректный адрес электронной почты"
                )
            )
        }
        
        return nil
    }
    
    func validateLicense(_ license: String?) -> InputFieldError? {
        guard let license = license, !license.isEmpty else {
            return InputFieldError(field: .license, errorType: .requiredFieldIsEmpty)
        }
        
        let licenseRegexp = "[A-Z][0-9]{3}[A-Z]{2}[0-9]{2,3}"
        guard validate(text: license, regexp: licenseRegexp) else {
            return InputFieldError(
                field: .license,
                errorType: .incorrectData(
                    message: "Введите корректный номер автомобиля"
                )
            )
        }
        
        return nil
    }
    
    func validatePhone(_ phone: String?) -> InputFieldError? {
        guard let phone = phone, !phone.isEmpty else {
            return InputFieldError(field: .phone, errorType: .requiredFieldIsEmpty)
        }
        
        let phoneRegexp = "^((8|\\+7)[\\- ]?)?(\\(?\\d{3}\\)?[\\- ]?)?[\\d\\- ]{7,10}$"
        guard validate(text: phone, regexp: phoneRegexp) else {
            return InputFieldError(
                field: .phone,
                errorType: .incorrectData(
                    message: "Введите корректный номер телефона"
                )
            )
        }
        
        return nil
    }
    
    func validatePassword(_ password: String?) -> InputFieldError? {
        guard let password = password, !password.isEmpty else {
            return InputFieldError(field: .password, errorType: .requiredFieldIsEmpty)
        }
        
        let passwordRegexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{6,}$"
        
        guard validate(text: password, regexp: passwordRegexp) else {
            return InputFieldError(
                field: .password,
                errorType: .incorrectData(
                    message: "Пароль должен быть не менее 6 символов длиной, содержать строчные и прописные латинские буквы и цифры"
                )
            )
        }
        
        
        
        return nil
    }
    
    func validatePasswordConfirmation(
        _ passwordConfirmation: String?,
        password: String?
        ) -> InputFieldError?
    {
        guard let passwordConfirmation = passwordConfirmation, !passwordConfirmation.isEmpty else {
            return InputFieldError(field: .passwordConfirmation, errorType: .requiredFieldIsEmpty)
        }
        
        guard password == passwordConfirmation else {
            return InputFieldError(
                field: .passwordConfirmation,
                errorType: .incorrectData(
                    message: "Пароли должны совпадать"
                )
            )
        }
        
        return nil
    }
    
    func validate(text: String, regexp: String) -> Bool {
        let testPredicate = NSPredicate(format: "SELF MATCHES %@", regexp)
        let string = text.replacingOccurrences(of: " ", with: "")
        
        return !isEmptyOrNil(string) && testPredicate.evaluate(with: string)
    }
}
