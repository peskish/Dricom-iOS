enum InputField {
    case name
    case email
    case license
    case phone
    case password
    case passwordConfirmation
}

struct InputFieldError {
    enum ErrorType {
        case incorrectData(message: String)
        case requiredFieldIsEmpty
    }
    
    let field: InputField
    let errorType: ErrorType
}
