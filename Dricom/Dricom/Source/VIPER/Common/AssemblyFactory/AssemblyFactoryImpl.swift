final class AssemblyFactoryImpl: AssemblyFactory {
    func applicationAssembly() -> ApplicationAssembly {
        return ApplicationAssemblyImpl(assemblyFactory: self)
    }
}
