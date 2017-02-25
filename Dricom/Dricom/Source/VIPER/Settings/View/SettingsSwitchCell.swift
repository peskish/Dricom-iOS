import UIKit

class SettingsSwitchCell: UITableViewCell {
    private let switchView = UISwitch()
    
    // MARK: Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.drcPaleGrey
        
        textLabel?.font = UIFont.drcSettingsCellTitleFont()
        textLabel?.textColor = UIColor.drcSlate
        
        contentView.addSubview(switchView)
        
        switchView.tintColor = UIColor.drcBlue
        switchView.onTintColor = UIColor.drcBlue
        
        switchView.addTarget(self, action: #selector(onSwitchValueChange(_:)), for: .valueChanged)
        
        accessoryView = switchView
    }
    
    static var reuseIdentifier: String? {
        return String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View data
    private var onValueChange: ((_ isOn: Bool) -> ())?
    func setViewData(_ viewData: SettingsViewData.Switcher) {
        textLabel?.text = viewData.title
        switchView.setOn(viewData.isOn, animated: false)
        self.onValueChange = viewData.onValueChange
    }
    
    // MARK: - Private
    @objc private func onSwitchValueChange(_ sender: UIControl) {
        onValueChange?(switchView.isOn)
    }
}
