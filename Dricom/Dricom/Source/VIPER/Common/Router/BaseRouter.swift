class BaseRouter {
    // MARK: - Properties
    let assemblyFactory: AssemblyFactory
    
    // MARK: - Init
    init(assemblyFactory: AssemblyFactory) {
        self.assemblyFactory = assemblyFactory
    }
}
