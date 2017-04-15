import Foundation

protocol MainPageViewInput: class, ViewLifecycleObservable, MessageDisplayable, ActivityDisplayable {
    func setName(_ name: String?)
    func setAvatarImageUrl(_ avatarImageUrl: URL?)
    func setLicenseParts(_ licenseParts: LicenseParts)
    func setLicenseSearchPlaceholder(_ placeholder: String?)
    func setLicenseSearchTitle(_ title: String)
    func setSearchButtonEnabled(_ enabled: Bool)
    func setOnSearchButtonTap(_ onSearchButtonTap: ((String?) -> ())?)
    
    var onLicenseSearchChange: ((String?) -> ())? { get set }
}
