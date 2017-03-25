import UIKit

protocol UserProfileViewInput: class,
    ViewLifecycleObservable,
    ActivityDisplayable,
    MessageDisplayable,
    InputFieldsContainer
{
    func setViewTitle(_ title: String)
    func setRightButton(title: String, onTap: @escaping () -> ())
    func setRightButtonEnabled(_ isEnabled: Bool)
    func setInputFieldsEnabled(_ isEnabled: Bool)
    func setAvatarSelectionEnabled(_ isEnabled: Bool)
    var onChangePhotoButtonTap: (() -> ())? { get set }
    func setAvatarPhotoImage(_ image: UIImage?)
    func setAvatarImageUrl(_ avatarImageUrl: URL?)
    func setAddPhotoTitle(_ title: String)
    func setAddPhotoTitleVisible(_ isVisible: Bool)
    func endEditing()
}
