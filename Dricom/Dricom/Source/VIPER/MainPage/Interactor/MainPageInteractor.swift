import Foundation

protocol MainPageInteractor: class {
    func user(completion: (User) -> ())
}
