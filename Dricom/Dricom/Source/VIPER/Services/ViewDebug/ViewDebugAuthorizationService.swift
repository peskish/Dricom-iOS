import Foundation

final class ViewDebugAuthorizationServiceImpl: AuthorizationService {
    var errorShown = false
    
    func login(userName: String, password: String, completion: @escaping ApiResult<User>.Completion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.errorShown {
                self.errorShown = true
                completion(
                    .error(
                        .apiError(ApiError(code: 403, message: "Неверная пара имя пользователя/пароль"))
                    )
                )
            } else {
                let user = User(
                    avatar: "http://www.indebioscoop.com/wp-content/afbeeldingen/2012/05/avatar.jpg",
                    name: "Ivan",
                    licence: "P245YC99",
                    phone: "+7 926 8756587",
                    email: "ivan@ivan.ru"
//                    userId: "12345"
                )
                completion(.data(user))
            }
        }
    }
}
