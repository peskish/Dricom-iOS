import UIKit

protocol RegisterViewInput: class,
    ViewLifecycleObservable,
    MessageDisplayable,
    ActivityDisplayable,
    InputFieldsContainer
{
    func setViewTitle(_ title: String)
    func setAddPhotoTitle(_ title: String)
    func setAddPhotoButtonVisible(_ visible: Bool)
    func setAvatarPhotoImage(_ image: UIImage?)
    func setRegisterButtonTitle(_ title: String)
    func endEditing()
    func setUserInteractionEnabled(_ isEnabled: Bool)
    
    var onAddPhotoButtonTap: (() -> ())? { get set }
    var onRegisterButtonTap: (() -> ())? { get set }
}
