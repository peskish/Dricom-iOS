import UIKit

final class ChatListViewController: BaseViewController, ChatListViewInput {
    // MARK: - Properties
    fileprivate let chatsTable = UITableView(frame: .zero, style: .plain)
    
    // MARK: - State
    fileprivate var state: ChatListViewState = .undefined
    var shouldReloadOnViewWillAppear = false
    
    // MARK: - ChatListViewInput
    func setViewTitle(_ title: String) {
        self.title = title
    }
    
    func setState(_ state: ChatListViewState) {
        self.state = state
        reloadData()
    }
    
    // MARK: - View events
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldReloadOnViewWillAppear {
            shouldReloadOnViewWillAppear = false
            chatsTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(chatsTable)
        
        automaticallyAdjustsScrollViewInsets = false
        
        chatsTable.backgroundColor = UIColor.drcWhite
        chatsTable.delegate = self
        chatsTable.dataSource = self
        
        chatsTable.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.reuseIdentifier)
        chatsTable.register(ChatListEmptyCell.self, forCellReuseIdentifier: ChatListEmptyCell.reuseIdentifier)
        
        chatsTable.tableHeaderView = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        )
        chatsTable.tableFooterView = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        )
        chatsTable.sectionHeaderHeight = .leastNormalMagnitude
        chatsTable.sectionFooterHeight = .leastNormalMagnitude
        chatsTable.separatorStyle = .none
        
        navigationController?.setStyle(.main)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        chatsTable.frame = view.bounds
    }
    
    // MARK: - Private
    private func reloadData() {
        if isOnScreen {
            chatsTable.reloadData()
        } else {
            shouldReloadOnViewWillAppear = true
        }
    }
}

extension ChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let rowData = rowData(for: indexPath) else { return }
        
        rowData.onTap?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch state {
        case .empty:
            return chatsTable.bounds.shrinked(chatsTable.contentInset).height
        case .data:
            return 101
        case .undefined:
            return 0
        }
    }
}

extension ChatListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .data(let rowDataList):
            return rowDataList.count
        case .empty:
            return 1
        case .undefined:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .data:
            return chatCell(indexPath: indexPath)
        case .empty:
            return emptyListCell()
        case .undefined:
            return UITableViewCell()
        }
    }
    
    // MARK: - Private
    fileprivate func rowData(for indexPath: IndexPath) -> ChatListRowData? {
        switch state {
        case .data(let rowDataList):
            return rowDataList.elementAtIndex(indexPath.row)
        default:
            return nil
        }
    }
    
    fileprivate func emptyRowData() -> ChatListEmptyRowData? {
        switch state {
        case .empty(let rowData):
            return rowData
        default:
            return nil
        }
    }
    
    private func chatCell(indexPath: IndexPath) -> UITableViewCell {
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
    
    private func emptyListCell() -> UITableViewCell {
        guard let rowData = emptyRowData() else {
            return UITableViewCell()
        }
        
        if let cell = chatsTable.dequeueReusableCell(
            withIdentifier: ChatListEmptyCell.reuseIdentifier) as? ChatListEmptyCell {
            cell.setViewData(rowData)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
