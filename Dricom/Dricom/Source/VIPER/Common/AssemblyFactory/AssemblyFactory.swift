protocol AssemblyFactory: class {
    func appStarterAssembly() -> AppStarterAssembly
    func applicationAssembly() -> ApplicationAssembly
    func loginAssembly() -> LoginAssembly
    func feedbackAssembly() -> FeedbackAssembly
    func mailComposerAssembly() -> MailComposerAssembly
    func registerAssembly() -> RegisterAssembly
    func cameraAssembly() -> CameraAssembly
    func mainPageAssembly() -> MainPageAssembly
    func settingsAssembly() -> SettingsAssembly
    func userProfileAssembly() -> UserProfileAssembly
}
