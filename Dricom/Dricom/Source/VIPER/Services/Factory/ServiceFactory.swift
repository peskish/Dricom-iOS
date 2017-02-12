protocol ServiceFactory {
    // MARK: - Data services
    func authorizationService() -> AuthorizationService
    func registrationService() -> RegistrationService
    func mailComposeDelegateService() -> MailComposeDelegateService
    func registerDataValidationService() -> RegisterDataValidationService
}

final class ServiceFactoryImpl: ServiceFactory {
    // MARK: - Properties
    private let networkClient = NetworkClientImpl()
    
    // MARK: - ServiceFactory
    func registrationService() -> RegistrationService {
        return RegistrationServiceImpl(
            networkClient: networkClient
        )
    }
    
    func authorizationService() -> AuthorizationService {
        return AuthorizationServiceImpl(
            networkClient: networkClient
        )
    }
    
    func mailComposeDelegateService() -> MailComposeDelegateService {
        return MailComposeDelegateServiceImpl()
    }
    
    func registerDataValidationService() -> RegisterDataValidationService {
        return RegisterDataValidationServiceImpl()
    }
}
