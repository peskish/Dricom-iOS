import UIKit

final class ChatListViewController: BaseViewController, ChatListViewInput {
    // MARK: - Properties
    fileprivate let chatsTable = UITableView(frame: .zero, style: .plain)
    
    // MARK: - State
    fileprivate var rowDataList = [ChatListRowData]()
    
    // MARK: - ChatListViewInput
    func setViewTitle(_ title: String) {
        self.title = title
    }
    
    func setRowDataList(_ rowDataList: [ChatListRowData]) {
        self.rowDataList = rowDataList
        chatsTable.reloadData()
    }
    
    // MARK: - View events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(chatsTable)
        
        automaticallyAdjustsScrollViewInsets = false
        
        chatsTable.backgroundColor = UIColor.drcWhite
        chatsTable.delegate = self
        chatsTable.dataSource = self
        
        chatsTable.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.reuseIdentifier)
        
        chatsTable.rowHeight = 101
        chatsTable.tableHeaderView = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        )
        chatsTable.tableFooterView = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        )
        chatsTable.sectionHeaderHeight = .leastNormalMagnitude
        chatsTable.sectionFooterHeight = .leastNormalMagnitude
        
        navigationController?.setStyle(.main)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        chatsTable.frame = view.bounds
    }
}

extension ChatListViewController: UITableViewDelegate {
    fileprivate func rowData(for indexPath: IndexPath) -> ChatListRowData? {
        return rowDataList.elementAtIndex(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let rowData = rowData(for: indexPath) else { return }
        
        rowData.onTap?()
    }
}

extension ChatListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowData = rowData(for: indexPath) else {
            return UITableViewCell()
        }
        
        if let cell = chatsTable.dequeueReusableCell(
            withIdentifier: ChatListCell.reuseIdentifier) as? ChatListCell {
            cell.setViewData(rowData)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
