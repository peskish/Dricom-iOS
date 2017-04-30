import UIKit

final class SettingsViewController: BaseViewController, SettingsViewInput {
    // MARK: - Properties
    fileprivate let settingsView = UITableView(frame: .zero, style: .grouped)
    
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
        
        settingsView.register(SettingsActionCell.self, forCellReuseIdentifier: SettingsActionCell.reuseIdentifier)
        settingsView.register(SettingsSelectCell.self, forCellReuseIdentifier: SettingsSelectCell.reuseIdentifier)
        settingsView.register(SettingsSwitchCell.self, forCellReuseIdentifier: SettingsSwitchCell.reuseIdentifier)
        
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
        
        navigationController?.setStyle(.main)
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
            if let cell = settingsView.dequeueReusableCell(
                withIdentifier: SettingsActionCell.reuseIdentifier) as? SettingsActionCell {
                cell.setViewData(actionData)
                return cell
            } else {
                return UITableViewCell()
            }
        case .select(let selectData):
            if let cell = settingsView.dequeueReusableCell(
                withIdentifier: SettingsSelectCell.reuseIdentifier) as? SettingsSelectCell {
                cell.setViewData(selectData)
                return cell
            } else {
                return UITableViewCell()
            }
        case .switcher(let switcherData):
            if let cell = settingsView.dequeueReusableCell(
                withIdentifier: SettingsSwitchCell.reuseIdentifier) as? SettingsSwitchCell {
                cell.setViewData(switcherData)
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
}
