import UIKit

final class SettingsViewController: BaseViewController, SettingsViewInput {
    // MARK: - Properties
    private let settingsView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - State
    fileprivate var viewData: SettingsViewData?
    
    // MARK: - View events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(settingsView)
        
        automaticallyAdjustsScrollViewInsets = false
        
        settingsView.backgroundColor = UIColor.drcWhite
        settingsView.delegate = self
        settingsView.dataSource = self
        
        settingsView.bounces = false
        settingsView.rowHeight = 50
        settingsView.tableHeaderView = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        )
        settingsView.tableFooterView = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        )
        settingsView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        settingsView.sectionFooterHeight = SpecMargins.contentMargin
        
        // TODO: DRY
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.drcSlate,
            NSFontAttributeName: UIFont.drcScreenNameFont() ?? UIFont.systemFont(ofSize: 17)
        ]
        
        if let backgroundImage = UIImage.imageWithColor(UIColor.drcWhite) {
            navigationController?.navigationBar.setBackgroundImage(
                backgroundImage,
                for: .default
            )
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        settingsView.frame = view.bounds
    }
    
    // MARK: - SettingsViewInput
    func setViewTitle(_ title: String) {
        self.title = title
    }
    
    func setViewData(_ viewData: SettingsViewData) {
        self.viewData = viewData
        settingsView.reloadData()
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let rowData = rowData(for: indexPath) else { return }
        
        switch rowData {
        case .switcher:
            return
        case .action(let action):
            action.onTap?()
        case .select(let select):
            select.onTap?()
        }
    }
    
    fileprivate func rowData(for indexPath: IndexPath) -> SettingsViewData.Row? {
        return viewData?.sections.elementAtIndex(indexPath.section)?.items.elementAtIndex(indexPath.row)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewData?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData?.sections.elementAtIndex(section)?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowData = rowData(for: indexPath) else {
            return UITableViewCell()
        }
        
        return cellForRowData(rowData)
    }
    
    private func cellForRowData(_ rowData: SettingsViewData.Row) -> UITableViewCell {
        switch rowData {
        case .action(let actionData):
            let cell = SettingsActionCell(style: .default, reuseIdentifier: SettingsActionCell.reuseIdentifier)
            cell.setViewData(actionData)
            return cell
        case .select(let selectData):
            let cell = SettingsSelectCell(style: .default, reuseIdentifier: SettingsSelectCell.reuseIdentifier)
            cell.setViewData(selectData)
            return cell
        case .switcher(let switcherData):
            let cell = SettingsSwitchCell(style: .default, reuseIdentifier: SettingsSwitchCell.reuseIdentifier)
            cell.setViewData(switcherData)
            return cell
        }
    }
}
