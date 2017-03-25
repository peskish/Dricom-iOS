import Foundation

final class SettingsPresenter: SettingsModule
{
    // MARK: - Private properties
    private let interactor: SettingsInteractor
    private let router: SettingsRouter
    
    // MARK: - Init
    init(interactor: SettingsInteractor,
         router: SettingsRouter)
    {
        self.interactor = interactor
        self.router = router
        
        interactor.onUserDataReceived = { [weak self] user in
            self?.presentUser(user)
        }
    }
    
    // MARK: - Weak properties
    weak var view: SettingsViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.setViewTitle("Настройки")
    }
    
    private func presentUser(_ user: User) {
        let notificationsRow = SettingsViewData.Row.switcher(
            SettingsViewData.Switcher(
                title: "Уведомления",
                isOn: false, // TODO
                onValueChange: { [weak self] isOn in
                    self?.onNotificationsToggle(isOn)
                }
            )
        )
        
        
        let licenseValue: String
        if let licenseParts = LicenseParts(licenseNumber: user.license) {
            licenseValue = (licenseParts.firstLetter + licenseParts.numberPart + licenseParts.restLetters)
        } else {
            licenseValue = ""
        }
        let licenseRow = SettingsViewData.Row.select(
            SettingsViewData.Select(
                title: "Номер автомобиля",
                displayingValue: licenseValue,
                onTap: { [weak self] in
                    self?.onLicenseTap()
                }
            )
        )
        
        let profileRow = SettingsViewData.Row.select(
            SettingsViewData.Select(
                title: "Профиль",
                displayingValue: "",
                onTap: { [weak self] in
                    self?.onProfileTap()
                }
            )
        )
        
        let passwordChangeRow = SettingsViewData.Row.select(
            SettingsViewData.Select(
                title: "Изменить пароль",
                displayingValue: "",
                onTap: { [weak self] in
                    self?.onPasswordChangeTap()
                }
            )
        )
        
        let logOutRow = SettingsViewData.Row.action(
            SettingsViewData.Action(
                title: "Выйти",
                onTap: { [weak self] in
                    self?.logOut()
                }
            )
        )
        
        let firstSection = SettingsViewData.Section(
            items: [notificationsRow, licenseRow, profileRow, passwordChangeRow]
        )
        let secondSection = SettingsViewData.Section(
            items: [logOutRow]
        )
        
        let viewData = SettingsViewData(sections: [firstSection, secondSection])
        
        view?.setViewData(viewData)
    }
    
    private func onNotificationsToggle(_ isEnabled: Bool) {
        // TODO:
        print("Set value: \(isEnabled)")
    }
    
    private func onLicenseTap() {
        // TODO:
        print("onLicenseTap")
    }
    
    private func onProfileTap() {
        router.showUserProfile()
    }
    
    private func onPasswordChangeTap() {
        
    }
    
    private func logOut() {
        interactor.logOut { [weak self] in
            self?.router.showLogin { loginModule in
                loginModule.onFinish = { result in
                    self?.focusOnModule()
                }
            }
        }
    }
    
    // MARK: - SettingsModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
}
