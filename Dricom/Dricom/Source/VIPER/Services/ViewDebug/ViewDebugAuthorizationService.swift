final class ViewDebugAuthorizationServiceImpl: AuthorizationService {
    func login(userName: String, password: String, completion: ApiResult<Void>.Completion) {
        if Int.random() % 2 == 0 {
            completion(.data())
        } else {
            completion(.error(NetworkError(code: 403, message: "Неверная пара имя пользователя/пароль")))
        }
    }
}
