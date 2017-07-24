import UIKit

final class ChatListEmptyCell: UITableViewCell {
    // MARK: - Properties
    private let illustrationImageView = UIImageView(image: #imageLiteral(resourceName: "Empty chat list"))
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(illustrationImageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        
        backgroundColor = .drcWhite
        
        selectionStyle = .none
        
        titleLabel.font = SpecFonts.ralewaySemiBold(16)
        titleLabel.textColor = UIColor.drcSlate
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        messageLabel.font = SpecFonts.ralewayRegular(14)
        messageLabel.textColor = UIColor.drcCoolGrey
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        titleLabel.bottom = bounds.centerY
        titleLabel.centerX = bounds.centerX
        
        illustrationImageView.sizeToFit()
        illustrationImageView.centerX = bounds.centerX
        illustrationImageView.bottom = titleLabel.top - 30
        
        messageLabel.sizeToFit()
        messageLabel.top = titleLabel.bottom + 15
        messageLabel.centerX = bounds.centerX
    }
    
    // MARK: - Content
    func setViewData(_ viewData: ChatListEmptyRowData) {
        titleLabel.text = viewData.title
        messageLabel.text = viewData.message
        
        setNeedsLayout()
    }
}
