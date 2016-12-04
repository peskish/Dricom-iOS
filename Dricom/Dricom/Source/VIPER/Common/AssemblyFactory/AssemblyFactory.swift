protocol AssemblyFactory: class {
    func applicationAssembly() -> ApplicationAssembly
    func loginAssembly() -> LoginAssembly
    func feedbackAssembly() -> FeedbackAssembly
    func mailComposerAssembly() -> MailComposerAssembly
    func registerAssembly() -> RegisterAssembly
    func cameraAssembly() -> CameraAssembly
    func mainPageAssembly() -> MainPageAssembly
}
