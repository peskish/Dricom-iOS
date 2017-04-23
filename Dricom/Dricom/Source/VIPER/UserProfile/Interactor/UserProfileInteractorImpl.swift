import UIKit

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
            self?.userDataChangeSet.name = user.name
            self?.userDataChangeSet.phone = user.phone
            self?.userDataChangeSet.email = user.email
            
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
    
    func validateData(completion: @escaping (DataValidationResult) -> ()) {
        return dataValidationService.validateData(userDataChangeSet, completion: completion)
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
    
    func setAvatar(_ avatar: UIImage?) {
        userDataChangeSet.avatar = avatar
    }
    
    func saveChanges(completion: @escaping ApiResult<Void>.Completion) {
        userDataService.changeUserData(with: userDataChangeSet, completion: completion)
    }
}
