import UIKit

final class SettingsViewController: BaseViewController, SettingsViewInput {
    // MARK: - Properties
    private let settingsView = SettingsView()
    
    // MARK: - State
    fileprivate var viewData: SettingsViewData?
    
    // MARK: - View events
    override func loadView() {
        super.loadView()
        
        view = settingsView
        
        settingsView.delegate = self
        settingsView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewData?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData?.sections.elementAtIndex(section)?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return SpecMargins.contentMargin
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowData = viewData?
            .sections.elementAtIndex(indexPath.section)?
            .items.elementAtIndex(indexPath.row)
            else { return UITableViewCell() }
        
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
