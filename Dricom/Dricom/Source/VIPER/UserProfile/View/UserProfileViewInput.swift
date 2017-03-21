import Foundation

protocol UserProfileViewInput: class, ViewLifecycleObservable, ActivityDisplayable, MessageDisplayable {
    func setViewTitle(_ title: String)
    func setRightButton(title: String, onTap: @escaping () -> ())
    func setRightButtonEnabled(_ isEnabled: Bool)
    func setInputFieldsEnabled(_ isEnabled: Bool)
    func setAvatarSelectionEnabled(_ isEnabled: Bool)
}
