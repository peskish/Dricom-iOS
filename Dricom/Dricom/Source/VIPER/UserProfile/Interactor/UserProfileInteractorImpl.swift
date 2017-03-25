import UIKit

struct UserProfileDataChangeSet {
    var avatar: UIImage?
    var name: String?
    var email: String?
    var phone: String?
}

final class UserProfileInteractorImpl: UserProfileInteractor {
    // MARK: - Dependencies
    private let userDataService: UserDataService
    private let dataValidationService: DataValidationService
    
    // MARK: - State
    var userDataChangeSet = UserProfileDataChangeSet()
    
    // MARK: - Init
    init(userDataService: UserDataService, dataValidationService: DataValidationService) {
        self.userDataService = userDataService
        self.dataValidationService = dataValidationService
        
        self.userDataService.subscribe(self) { [weak self] user in
            self?.onUserDataReceived?(user)
        }
    }
    
    // MARK: - UserProfileInteractor
    func requestUserData(completion: ApiResult<Void>.Completion?) {
        userDataService.requestUserData(completion: completion)
    }
    
    var onUserDataReceived: ((User) -> ())?
    
    func validateName() -> InputFieldError? {
        return dataValidationService.validateName(userDataChangeSet.name)
    }
    
    func validateEmail() -> InputFieldError? {
        return dataValidationService.validateEmail(userDataChangeSet.email)
    }
    
    func validatePhone() -> InputFieldError? {
        return dataValidationService.validatePhone(userDataChangeSet.phone)
    }
    
    func setName(_ name: String?) {
        userDataChangeSet.name = name?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setEmail(_ email: String?) {
        userDataChangeSet.email = email?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setPhone(_ phone: String?) {
        userDataChangeSet.phone = phone?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
