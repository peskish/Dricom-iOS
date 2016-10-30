final class ViewDebugRegistrationService: RegistrationService {
    // MARK: - RegistrationService
    func register(
        with data: RegistrationData,
        completion: (DataResult<SessionInfo, NetworkError>) -> ())
    {
        let sessionInfo = SessionInfo(
            session: "12SessIOn456",
            userName: "Иван Петров",
            licence: "PY234C99RU",
            phone: "+7909123456"
        )
        completion(.data(sessionInfo))
    }
}
