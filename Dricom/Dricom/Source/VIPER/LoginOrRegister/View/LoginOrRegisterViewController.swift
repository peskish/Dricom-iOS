import UIKit

final class LoginOrRegisterViewController: BaseViewController, LoginOrRegisterViewInput {
    private let loginOrRegisterView = LoginOrRegisterView()
    
    override func loadView() {
        super.loadView()
        
        view = loginOrRegisterView
    }
    
    // MARK: - LoginOrRegisterViewInput
}
