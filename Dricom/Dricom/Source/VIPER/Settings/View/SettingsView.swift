import UIKit

final class SettingsView: UITableView {
    // MARK: - Init
    init() {
        super.init(frame: .zero, style: .grouped)
        
        backgroundColor = UIColor.drcWhite
        tableHeaderView = nil
        tableFooterView = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
