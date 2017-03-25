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
    
    
    var onAddPhotoButtonTap: (() -> ())? { get set }
    var onRegisterButtonTap: (() -> ())? { get set }
}
