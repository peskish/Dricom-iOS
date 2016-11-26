import Foundation

final class ViewDebugAuthorizationServiceImpl: AuthorizationService {
    func login(userName: String, password: String, completion: @escaping ApiResult<Void>.Completion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if Int.random() % 2 == 0 {
                completion(.data())
            } else {
                completion(.error(NetworkError(code: 403, message: "Неверная пара имя пользователя/пароль")))
            }
        }
    }
}
