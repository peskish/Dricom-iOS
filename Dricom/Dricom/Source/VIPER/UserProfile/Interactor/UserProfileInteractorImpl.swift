import UIKit

final class UserProfileInteractorImpl: UserProfileInteractor {
    // MARK: - Dependencies
    private let userDataService: UserDataService
    private let dataValidationService: DataValidationService
    
    // MARK: - State
    var originalChangeSet = UserProfileDataChangeSet()
    var updatedChangeSet = UserProfileDataChangeSet()
    
    // MARK: - Init
    init(userDataService: UserDataService, dataValidationService: DataValidationService) {
        self.userDataService = userDataService
        self.dataValidationService = dataValidationService
        
        self.userDataService.subscribe(self) { [weak self] user in
            guard let `self` = self else { return }
            
            self.originalChangeSet.name = user.name
            self.originalChangeSet.phone = user.phone
            self.originalChangeSet.email = user.email
            self.originalChangeSet.avatar = nil
            
            self.updatedChangeSet = self.originalChangeSet
            
            self.onUserDataReceived?(user)
        }
    }
    
    // MARK: - UserProfileInteractor
    func requestUserData(completion: ApiResult<Void>.Completion?) {
        userDataService.requestUserData(completion: completion)
    }
    
    var onUserDataReceived: ((User) -> ())?
    
    func validateName() -> InputFieldError? {
        return dataValidationService.validateName(updatedChangeSet.name)
    }
    
    func validateEmail() -> InputFieldError? {
        return dataValidationService.validateEmail(updatedChangeSet.email)
    }
    
    func validatePhone() -> InputFieldError? {
        return dataValidationService.validatePhone(updatedChangeSet.phone)
    }
    
    func validateData(completion: @escaping (DataValidationResult) -> ()) {
        return dataValidationService.validateData(updatedChangeSet, completion: completion)
    }
    
    func setName(_ name: String?) {
        updatedChangeSet.name = name?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setEmail(_ email: String?) {
        updatedChangeSet.email = email?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setPhone(_ phone: String?) {
        updatedChangeSet.phone = phone?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setAvatar(_ avatar: UIImage?) {
        updatedChangeSet.avatar = avatar
    }
    
    func hasChanges() -> Bool {
        return hasChangesInFields() || updatedChangeSet.avatar != nil
    }
    
    func saveChanges(completion: @escaping ApiResult<Void>.Completion) {
        if hasChangesInFields() {
            userDataService.changeUserData(with: updatedChangeSet, completion: completion)
        } else if let avatar = updatedChangeSet.avatar {
            userDataService.changeUserAvatar(avatar, completion: completion)
        }
    }
    
    // MARK: - Private
    private func hasChangesInFields() -> Bool {
        return originalChangeSet.name != updatedChangeSet.name
            || originalChangeSet.phone != updatedChangeSet.phone
            || originalChangeSet.email != updatedChangeSet.email
    }
}
