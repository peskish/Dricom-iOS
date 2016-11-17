import UIKit

protocol RegisterInteractor: class {
    func hasAvatar() -> Bool
    func setAvatar(_ avatar: UIImage?)
}
