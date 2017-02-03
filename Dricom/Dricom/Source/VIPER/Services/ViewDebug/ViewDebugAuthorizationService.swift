import Foundation

final class ViewDebugAuthorizationServiceImpl: AuthorizationService {
    var errorShown = false
    
    func login(userName: String, password: String, completion: @escaping ApiResult<User>.Completion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.errorShown {
                self.errorShown = true
                completion(.error(NetworkError(code: 403, message: "Неверная пара имя пользователя/пароль")))
            } else {
                let user = User(
                    userId: "12345",
                    avatar: "http://www.indebioscoop.com/wp-content/afbeeldingen/2012/05/avatar.jpg",
                    userName: "Ivan",
                    licence: "P245YC99",
                    phone: "+7 926 8756587"
                )
                completion(.data(user))
            }
        }
    }
}
