import UIKit

final class MainPageViewController: BaseViewController, MainPageViewInput {
    // MARK: - Properties
    private let mainPageView = MainPageView()
    
    // MARK: - View events
    override func loadView() {
        super.loadView()
        
        view = mainPageView
    }
    
    // MARK: - MainPageViewInput
}
