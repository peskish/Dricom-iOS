final class ViewDebugServiceFactory: ServiceFactory {
    func registrationService() -> RegistrationService {
        return ViewDebugRegistrationService()
    }
}
