protocol UserSearchService: class {
    func searchUser(license: String, completion: @escaping ApiResult<User?>.Completion)
}

final class UserSearchServiceImpl: UserSearchService {
    // MARK: - Dependencies
    private let dataValidationService: DataValidationService
    private let networkClient: NetworkClient
    
    // MARK: - Init
    init(dataValidationService: DataValidationService, networkClient: NetworkClient) {
        self.dataValidationService = dataValidationService
        self.networkClient = networkClient
    }
    
    // MARK: - UserSearchService
    func searchUser(license: String, completion: @escaping ApiResult<User?>.Completion) {
        guard let normalizedLicense = LicenseNormalizer.normalize(license: license) else {
            completion(.error(.wrongInputParameters(message: "Введите номер")))
            return
        }
        
        if let licenseError = dataValidationService.validateLicense(normalizedLicense) {
            completion(.error(.wrongInputParameters(message: message(from: licenseError))))
            return
        }
        
        let request = SearchUserRequest(license: normalizedLicense)
        
        networkClient.send(request: request) { result in
            result.onData { searchUserResult in
                completion(.data(searchUserResult.results.first))
            }
            result.onError { error in
                completion(.error(error))
            }
        }
    }
    
    // MARK: - Private
    private func message(from inputFieldError: InputFieldError) -> String {
        switch inputFieldError.errorType {
        case .requiredFieldIsEmpty:
            return "Введите номер"
        case .incorrectData(let validationErrorMessage):
            return validationErrorMessage
        }
    }
}
