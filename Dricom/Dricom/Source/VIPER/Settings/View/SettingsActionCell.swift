import UIKit

class SettingsActionCell: UITableViewCell {
    // MARK: Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        backgroundView?.backgroundColor = UIColor.drcPaleGrey
        backgroundView?.alpha = 0.5
        
        textLabel?.font = UIFont.drcSettingsCellTitleFont()
        textLabel?.textColor = UIColor.drcBlue
    }
    
    static var reuseIdentifier: String? {
        return String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View data
    func setViewData(_ viewData: SettingsViewData.Action) {
        textLabel?.text = viewData.title
    }
}
