protocol AssemblyFactory: class {
    func applicationAssembly() -> ApplicationAssembly
    func loginOrRegisterAssembly() -> LoginOrRegisterAssembly
    func loginAssembly() -> LoginAssembly
    func feedbackAssembly() -> FeedbackAssembly
}
