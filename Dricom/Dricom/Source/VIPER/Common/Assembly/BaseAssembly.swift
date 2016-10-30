class BaseAssembly {
    // MARK: - Properties
    let assemblyFactory: AssemblyFactory
    let serviceFactory: ServiceFactory
    
    // MARK: - Init
    init(assemblyFactory: AssemblyFactory, serviceFactory: ServiceFactory) {
        self.assemblyFactory = assemblyFactory
        self.serviceFactory = serviceFactory
    }
}
