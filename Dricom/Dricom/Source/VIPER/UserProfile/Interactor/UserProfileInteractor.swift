import UIKit

protocol UserProfileInteractor: class {
    func requestUserData(completion: ApiResult<Void>.Completion?)
    var onUserDataReceived: ((User) -> ())? { get set }
    func setName(_ name: String?)
    func setEmail(_ email: String?)
    func setPhone(_ phone: String?)
    func validateName() -> InputFieldError?
    func validateEmail() -> InputFieldError?
    func validatePhone() -> InputFieldError?
    func validateData(completion: @escaping (DataValidationResult) -> ())
    func setAvatar(_ avatar: UIImage?)
    func saveChanges(completion: @escaping ApiResult<Void>.Completion)
}
