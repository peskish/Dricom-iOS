import UIKit

class MainPageUsersTableView: UIView {
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - State
    fileprivate var userRowViewDataList = [UserRowViewData]()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        tableView.backgroundColor = UIColor.drcWhite
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UserRowTableViewCell.self, forCellReuseIdentifier: UserRowTableViewCell.reuseIdentifier)
        
        tableView.bounces = false
        tableView.rowHeight = 70
        tableView.tableHeaderView = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        )
        tableView.tableFooterView = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        )
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
    // MARK: - Content
    func setViewDataList(_ userRowViewDataList: [UserRowViewData]) {
        self.userRowViewDataList = userRowViewDataList
        tableView.reloadData()
    }
    
    // MARK: - Unused
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainPageUsersTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let viewData = userRowViewDataList.elementAtIndex(indexPath.row) {
            viewData.onTap?()
        }
    }
}

extension MainPageUsersTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRowViewDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: UserRowTableViewCell.reuseIdentifier) as? UserRowTableViewCell {
            if let viewData = userRowViewDataList.elementAtIndex(indexPath.row) {
                cell.setViewData(viewData)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

