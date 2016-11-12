import UIKit

final class RegisterViewController: BaseViewController, RegisterViewInput {
    // MARK: - Properties
    private let registerView = RegisterView()
    
    // MARK: - View events
    override func loadView() {
        super.loadView()
        
        view = registerView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        registerView.initialInsets = .zero
    }
    
    // MARK: - RegisterViewInput
}
