import UIKit

// TODO: Вьюшки, лэйаут
final class ChatListCell: UITableViewCell {
    // MARK: Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.drcWhite
        
//        textLabel?.font = UIFont.drcSettingsCellTitleFont()
//        textLabel?.textColor = UIColor.drcSlate
//        
//        detailTextLabel?.font = UIFont.drcSettingsSelectValueFont()
//        detailTextLabel?.textColor = UIColor.drcSlate60
        
        selectionStyle = .gray
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View data
    func setViewData(_ viewData: ChatListRowData) {
//        textLabel?.text = viewData.title
//        detailTextLabel?.text = viewData.displayingValue
    }
}
