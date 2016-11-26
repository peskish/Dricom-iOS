struct RegistrationData {
    var avatarImageId: String?
    var name: String?
    var email: String?
    var phone: String?
    var license: String?
    var password: String?
    let token: String?
}

protocol RegistrationService {
    func register(with data: RegistrationData, completion: @escaping ApiResult<Void>.Completion)
}
