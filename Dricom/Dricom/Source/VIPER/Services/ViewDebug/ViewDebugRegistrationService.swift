import Foundation

final class ViewDebugRegistrationService: RegistrationService {
    // MARK: - RegistrationService
    func register(
        with data: RegistrationData,
        completion: @escaping (DataResult<Void, NetworkError>) -> ())
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if Int.random() % 2 == 0 {
                completion(.data())
            } else {
                completion(.error(NetworkError(code: 403, message: "Такой пользователь уже зарегистрирован")))
            }
        }
    }
}
