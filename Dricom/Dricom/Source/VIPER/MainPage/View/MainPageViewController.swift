import UIKit

final class MainPageViewController: BaseViewController, MainPageViewInput {
    // MARK: - Properties
    private let mainPageView = MainPageView()
    
    // MARK: - View events
    override func loadView() {
        super.loadView()
        
        view = mainPageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mainPageView.contentInset = defaultContentInsets
    }
    
    // MARK: - MainPageViewInput
    func setAvatarImageUrl(_ avatarImageUrl: URL?) {
        mainPageView.setAvatarImageUrl(avatarImageUrl)
    }
    
    func setName(_ name: String?) {
        mainPageView.setName(name)
    }
    
    func setLicenseParts(_ licenseParts: LicenseParts) {
        mainPageView.setLicenseParts(licenseParts)
    }
    
    func setLicenseSearchPlaceholder(_ placeholder: String?) {
        mainPageView.setLicenseSearchPlaceholder(placeholder)
    }
    
    var onLicenseSearchChange: ((String?) -> ())? {
        get { return mainPageView.onLicenseSearchChange }
        set { mainPageView.onLicenseSearchChange = newValue }
    }
    
    func setLicenseSearchTitle(_ title: String) {
        mainPageView.setLicenseSearchTitle(title)
    }
    
    func setOnSearchButtonTap(_ onSearchButtonTap: ((String?) -> ())?) {
        mainPageView.setOnSearchButtonTap(onSearchButtonTap)
    }
    
    // MARK: ActivityDisplayable
    func startActivity() {
        mainPageView.startActivity()
    }
    
    func stopActivity() {
        mainPageView.stopActivity()
    }
}
