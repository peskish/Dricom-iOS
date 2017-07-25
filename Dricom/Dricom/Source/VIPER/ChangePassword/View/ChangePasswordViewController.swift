import UIKit

final class ChangePasswordViewController: BaseViewController, ChangePasswordViewInput, InputFieldsContainerHolder
{
    // MARK: - Properties
    private let changePasswordView = ChangePasswordView()
    
    // MARK: - View events
    override func loadView() {
        view = changePasswordView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setStyle(.main)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - ChangePasswordViewInput
    func setScreenTitle(_ title: String) {
        self.title = title
    }
    
    func setCancelButtonTitle(_ title: String) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(onCancelButtonTap(_:))
        )
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(
            [NSForegroundColorAttributeName: UIColor.drcBlue,
             NSFontAttributeName: SpecFonts.ralewayMedium(14)],
            for: .normal
        )
    }
    
    var onCancelButtonTap: (() -> ())?
    @objc private func onCancelButtonTap(_ sender: UIBarButtonItem) {
        onCancelButtonTap?()
    }
    
    func setConfirmButtonTitle(_ title: String) {
        changePasswordView.setConfirmButtonTitle(title)
    }
    
    func setConfirmButtonEnabled(_ enabled: Bool) {
        changePasswordView.setConfirmButtonEnabled(enabled)
    }
    
    var onConfirmButtonTap: (() -> ())? {
        get { return changePasswordView.onConfirmButtonTap }
        set { changePasswordView.onConfirmButtonTap = newValue }
    }
    
    func endEditing() {
        changePasswordView.endEditing(true)
    }
    
    func setUserInteractionEnabled(_ isEnabled: Bool) {
        view.isUserInteractionEnabled = isEnabled
        navigationController?.navigationBar.isUserInteractionEnabled = isEnabled
        navigationController?.view.isUserInteractionEnabled = isEnabled
    }
    
    // MARK: ActivityDisplayable
    func startActivity() {
        changePasswordView.startActivity()
    }
    
    func stopActivity() {
        changePasswordView.stopActivity()
    }
    
    // MARK: InputFieldsContainerHolder
    var inputFieldsContainer: InputFieldsContainer {
        return changePasswordView
    }
}
