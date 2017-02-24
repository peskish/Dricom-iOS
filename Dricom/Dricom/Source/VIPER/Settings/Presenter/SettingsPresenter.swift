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
    }
    
    // MARK: - Weak properties
    weak var view: SettingsViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - SettingsModule
    func setUser(_ user: User) {
        interactor.setUser(user)
        presentUser(user)
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.setViewTitle("Настройки")
    }
    
    private func presentUser(_ user: User) {
        let notificationsRow = SettingsViewData.Row.switcher(
            SettingsViewData.Switcher(
                title: "Уведомления",
                isEnabled: false, // TODO
                onValueChange: { [weak self] isEnabled in
                    self?.onNotificationsToggle(isEnabled)
                }
            )
        )
        
        let licenseRow = SettingsViewData.Row.select(
            SettingsViewData.Select(
                title: "Номер автомобиля",
                displayingValue: user.license ?? "",
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
        // TODO:
        print("onProfileTap")
    }
    
    private func onPasswordChangeTap() {
        
    }
    
    private func logOut() {
        // TODO:
        print("logOut")
    }
    
    // MARK: - SettingsModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
}
