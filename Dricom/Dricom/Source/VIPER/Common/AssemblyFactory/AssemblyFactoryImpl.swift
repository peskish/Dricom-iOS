final class AssemblyFactoryImpl: AssemblyFactory {
    // MARK: Properties
    private let serviceFactory: ServiceFactory
    
    // MARK: Init
    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }
    
    // MARK: - AssemblyFactory
    func appStarterAssembly() -> AppStarterAssembly {
        return AppStarterAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
    
    func applicationAssembly() -> ApplicationAssembly {
        return ApplicationAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
    
    func loginAssembly() -> LoginAssembly {
        return LoginAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
    
    func feedbackAssembly() -> FeedbackAssembly {
        return FeedbackAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
    
    func mailComposerAssembly() -> MailComposerAssembly {
        return MailComposerAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
    
    func registerAssembly() -> RegisterAssembly {
        return RegisterAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
    
    func cameraAssembly() -> CameraAssembly {
        return CameraAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
    
    func mainPageAssembly() -> MainPageAssembly {
        return MainPageAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
    
    func settingsAssembly() -> SettingsAssembly {
        return SettingsAssemblyImpl(assemblyFactory: self, serviceFactory: serviceFactory)
    }
}
