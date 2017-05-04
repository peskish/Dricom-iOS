import Foundation

protocol ChangePasswordViewInput: class,
    ViewLifecycleObservable,
    MessageDisplayable,
    ActivityDisplayable,
    InputFieldsContainer
{
    func setScreenTitle(_ title: String)
    
    func setCancelButtonTitle(_ title: String)
    var onCancelButtonTap: (() -> ())? { get set }
    
    func setConfirmButtonTitle(_ title: String)
    func setConfirmButtonEnabled(_ enabled: Bool)
    var onConfirmButtonTap: (() -> ())? { get set }
    
    func endEditing()
    func setUserInteractionEnabled(_ isEnabled: Bool)
}
