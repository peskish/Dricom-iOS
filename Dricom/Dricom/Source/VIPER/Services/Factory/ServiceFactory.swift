protocol ServiceFactory {
    // MARK: - Data services
    func authorizationService() -> AuthorizationService
    func registrationService() -> RegistrationService
    func mailComposeDelegateService() -> MailComposeDelegateService
    func dataValidationService() -> DataValidationService
    func userDataService() -> UserDataService
    func userSearchService() -> UserSearchService
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
    
    func dataValidationService() -> DataValidationService {
        return DataValidationServiceImpl()
    }
    
    func userDataService() -> UserDataService {
        return userDataServiceInstance
    }
    
    func userSearchService() -> UserSearchService {
        return UserSearchServiceImpl(
            dataValidationService: dataValidationService(),
            networkClient: networkClientInstance
        )
    }
}
