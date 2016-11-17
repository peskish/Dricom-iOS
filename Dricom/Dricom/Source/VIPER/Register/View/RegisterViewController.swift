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
    func setAddPhotoTitle(_ title: String) {
        registerView.setAddPhotoTitle(title)
    }
    
    func setAddPhotoImage(_ image: UIImage?) {
        registerView.setAddPhotoImage(image)
    }
    
    var onAddPhotoButtonTap: (() -> ())? {
        get { return registerView.onAddPhotoButtonTap }
        set { registerView.onAddPhotoButtonTap = newValue }
    }
}
