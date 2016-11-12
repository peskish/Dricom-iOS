protocol AssemblyFactory: class {
    func applicationAssembly() -> ApplicationAssembly
    func loginAssembly() -> LoginAssembly
    func feedbackAssembly() -> FeedbackAssembly
    func mailComposerAssembly() -> MailComposerAssembly
}
