protocol ServiceFactory {
    // MARK: - Data services
    func authorizationService() -> AuthorizationService
    func registrationService() -> RegistrationService
    func mailComposeDelegateService() -> MailComposeDelegateService
    func registerDataValidationService() -> RegisterDataValidationService
    func userDataService() -> UserDataService
}

final class ServiceFactoryImpl: ServiceFactory {
    // MARK: - Properties
    private let networkClientInstance: NetworkClient
    private let authInfoHolderInstance: LoginResponseProcessor & AuthorizationStatusHolder & LastSuccessLoginHolder
    
    // MARK: - Init
    init() {
        authInfoHolderInstance = AuthInfoHolder()
        networkClientInstance = NetworkClientImpl(authorizationStatusHolder: authInfoHolderInstance)
    }
    
    // MARK: - ServiceFactory
    func networkClient() -> NetworkClient {
        return networkClientInstance
    }
    
    func registrationService() -> RegistrationService {
        return RegistrationServiceImpl(
            networkClient: networkClient(),
            loginResponseProcessor: authInfoHolderInstance
        )
    }
    
    func authorizationService() -> AuthorizationService {
        return AuthorizationServiceImpl(
            networkClient: networkClient(),
            loginResponseProcessor: authInfoHolderInstance
        )
    }
    
    func mailComposeDelegateService() -> MailComposeDelegateService {
        return MailComposeDelegateServiceImpl()
    }
    
    func registerDataValidationService() -> RegisterDataValidationService {
        return RegisterDataValidationServiceImpl()
    }
    
    func userDataService() -> UserDataService {
        return UserDataServiceImpl(networkClient: networkClient())
    }
}
