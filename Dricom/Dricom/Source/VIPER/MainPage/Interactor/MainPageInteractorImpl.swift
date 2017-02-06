import Foundation

final class MainPageInteractorImpl: MainPageInteractor {
    // MARK: - MainPageInteractor
    func user(completion: (User) -> ()) {
        let user = User(
            avatar: "http://www.indebioscoop.com/wp-content/afbeeldingen/2012/05/avatar.jpg",
            name: "Ivan",
            licence: "P245YC99",
            phone: "+7 926 8756587",
            email: "ivan@mail.ru"
//            userId: "12345"
        )
        
        completion(user)
    }
}
