import UIKit

final class SettingsSelectCell: UITableViewCell {
    // MARK: Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.drcPaleGrey
        
        textLabel?.font = UIFont.drcSettingsCellTitleFont()
        textLabel?.textColor = UIColor.drcSlate
        
        detailTextLabel?.font = UIFont.drcSettingsSelectValueFont()
        detailTextLabel?.textColor = UIColor.drcSlate60
        
        accessoryType = .disclosureIndicator
        selectionStyle = .gray
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View data
    func setViewData(_ viewData: SettingsViewData.Select) {
        textLabel?.text = viewData.title
        detailTextLabel?.text = viewData.displayingValue
    }
}
