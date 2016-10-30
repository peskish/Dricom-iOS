protocol AssemblyFactory: class {
    func applicationAssembly() -> ApplicationAssembly
    func loginOrRegisterAssembly() -> LoginOrRegisterAssembly
}
