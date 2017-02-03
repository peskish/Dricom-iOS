import UIKit

final class ApplicationTabBarController: UITabBarController, ApplicationViewInput, DisposeBag, DisposeBagHolder {
   
    
    // MARK: - DisposeBagHolder
    let disposeBag: DisposeBag = DisposeBagImpl()
}
