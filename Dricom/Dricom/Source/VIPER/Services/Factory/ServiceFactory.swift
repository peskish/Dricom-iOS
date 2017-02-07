protocol ServiceFactory {
    // MARK: - Data services
    func authorizationService() -> AuthorizationService
    func registrationService() -> RegistrationService
    func mailComposeDelegateService() -> MailComposeDelegateService
    func registerDataValidationService() -> RegisterDataValidationService
}

final class ServiceFactoryImpl: ServiceFactory {
    // TODO: продолжить, использовать ее и потестить запрос
    
    func registrationService() -> RegistrationService {
        return ViewDebugRegistrationService()
    }
    
    func authorizationService() -> AuthorizationService {
        return ViewDebugAuthorizationServiceImpl()
    }
    
    func mailComposeDelegateService() -> MailComposeDelegateService {
        return MailComposeDelegateServiceImpl()
    }
    
    func registerDataValidationService() -> RegisterDataValidationService {
        return RegisterDataValidationServiceImpl()
    }
}
