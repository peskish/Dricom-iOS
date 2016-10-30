final class AssemblyFactoryImpl: AssemblyFactory {
    // MARK: Properties
    private let serviceFactory: ServiceFactory
    
    // MARK: Init
    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }
    
    // MARK: - AssemblyFactory
    func applicationAssembly() -> ApplicationAssembly {
        return ApplicationAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
    
    func loginOrRegisterAssembly() -> LoginOrRegisterAssembly {
        return LoginOrRegisterAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
}
