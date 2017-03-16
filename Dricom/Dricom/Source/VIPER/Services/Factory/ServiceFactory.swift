protocol ServiceFactory {
    // MARK: - Data services
    func authorizationService() -> AuthorizationService
    func registrationService() -> RegistrationService
    func mailComposeDelegateService() -> MailComposeDelegateService
    func registerDataValidationService() -> RegisterDataValidationService
    func userDataService() -> UserDataService
    func logoutService() -> LogoutService
}

final class ServiceFactoryImpl: ServiceFactory {
    // MARK: - Properties
    private let networkClientInstance: NetworkClient
    private let authInfoHolderInstance: LoginResponseProcessor & AuthorizationStatusHolder & LastSuccessLoginHolder & LogoutService
    private let userDataServiceInstance: UserDataService & UserDataNotifier
    
    // MARK: - Init
    init() {
        authInfoHolderInstance = AuthInfoHolder()
        networkClientInstance = NetworkClientImpl(authorizationStatusHolder: authInfoHolderInstance)
        userDataServiceInstance = UserDataServiceImpl(networkClient: networkClientInstance)
    }
    
    // MARK: - ServiceFactory
    func registrationService() -> RegistrationService {
        return RegistrationServiceImpl(
            networkClient: networkClientInstance,
            loginResponseProcessor: authInfoHolderInstance,
            userDataNotifier: userDataServiceInstance
        )
    }
    
    func authorizationService() -> AuthorizationService {
        return AuthorizationServiceImpl(
            networkClient: networkClientInstance,
            loginResponseProcessor: authInfoHolderInstance,
            userDataNotifier: userDataServiceInstance
        )
    }
    
    func logoutService() -> LogoutService {
        return authInfoHolderInstance
    }
    
    func mailComposeDelegateService() -> MailComposeDelegateService {
        return MailComposeDelegateServiceImpl()
    }
    
    func registerDataValidationService() -> RegisterDataValidationService {
        return RegisterDataValidationServiceImpl()
    }
    
    func userDataService() -> UserDataService {
        return userDataServiceInstance
    }
}
