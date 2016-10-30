struct RegistrationData {
    let name: String
    let license: String
    let phone: String
    let password: String
    let token: String?
}

protocol RegistrationService {
    func register(with data: RegistrationData, completion: ApiResult<SessionInfo>.Completion)
}
