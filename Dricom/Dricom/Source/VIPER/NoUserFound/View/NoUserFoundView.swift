import UIKit

final class NoUserFoundView: UIView {
    // MARK: - Properties
    private let closeButton = ImageButtonView(image: #imageLiteral(resourceName: "Close blue"))
    private let sadCarImageView = UIImageView(image: #imageLiteral(resourceName: "SadCar"))
    private let messageLabel = UILabel(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(closeButton)
        addSubview(sadCarImageView)
        addSubview(messageLabel)
        addSubview(descriptionLabel)
        
        setUpStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpStyle() {
        backgroundColor = UIColor.drcWhite
        
        messageLabel.font = UIFont.drcNoUserMessageFont()
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.drcSlate
        
        descriptionLabel.font = UIFont.drcUserHintFont()
        descriptionLabel.textColor = UIColor.drcSlate
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Layout
    private let fixedLabelWidth: CGFloat = 255
    override func layoutSubviews() {
        super.layoutSubviews()
        
        closeButton.sizeToFit()
        closeButton.top = 10
        
        sadCarImageView.sizeToFit()
        sadCarImageView.top = 142
        sadCarImageView.centerX = bounds.centerX
        
        messageLabel.sizeToFit()
        messageLabel.top = sadCarImageView.bottom + 40
        messageLabel.centerX = bounds.centerX
        
        descriptionLabel.size = descriptionLabel.sizeThatFits(
            CGSize(width: fixedLabelWidth, height: .greatestFiniteMagnitude)
        )
        descriptionLabel.top = messageLabel.bottom + 15
        descriptionLabel.centerX = bounds.centerX
    }
    
    // MARK: - Public
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
    
    func setDescription(_ description: String) {
        descriptionLabel.text = description
    }
    
    var onCloseTap: (() -> ())? {
        get { return closeButton.onTap }
        set { closeButton.onTap = newValue }
    }
}
