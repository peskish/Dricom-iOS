import Foundation

protocol UserProfileInteractor: class {
    func requestUserData(completion: ApiResult<Void>.Completion?)
    var onUserDataReceived: ((User) -> ())? { get set }
    func setName(_ name: String?)
    func setEmail(_ email: String?)
    func setPhone(_ phone: String?)
    func validateName() -> InputFieldError?
    func validateEmail() -> InputFieldError?
    func validatePhone() -> InputFieldError?
}
