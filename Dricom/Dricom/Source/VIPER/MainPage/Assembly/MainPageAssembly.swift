import UIKit

protocol MainPageAssembly: class {
    func module(user: User) -> UIViewController
}
