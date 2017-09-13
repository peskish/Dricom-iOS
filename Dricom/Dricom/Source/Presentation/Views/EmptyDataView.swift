import UIKit

public enum EmptyDataStyle {
    case chat
    case search
    
    fileprivate var style: EmptyData {
        switch self {
        case .chat:
            return EmptyData(
                image: #imageLiteral(resourceName: "Empty chat list"),
                title: "У вас пока нет сообщений",
                description: "Найдите других автовладельцев через поиск и напишите ему сообщение. Новый разговор появится здесь.")
        case .search:
            return EmptyData(
                image: #imageLiteral(resourceName: "SadCarBlue"),
                title: "Упс! Такого пользователя нет",
                description: "Найдите автомобилиста в реальном мире и предложите воспользоваться данным приложением")
        }
    }
}

fileprivate struct EmptyData {
    let image: UIImage?
    let title: String?
    let description: String?
}

class EmptyDataView: UIView {
   
    // MARK: Properties
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        setupStyle()
    }
    
    convenience init(style: EmptyDataStyle) {
        self.init()
        
        setEmptyDataStyle(style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layout(
            left: SpecMargins.contentSidePadding,
            right: bounds.width - SpecMargins.contentSidePadding,
            top: 50,
            height: imageView.image?.size.height ?? 0
        )
        
        titleLabel.sizeToFit()
        titleLabel.layout(
            left: SpecMargins.contentSidePadding,
            right: bounds.width - SpecMargins.contentSidePadding,
            top: imageView.bottom + 30,
            height: titleLabel.height
        )
        
        descriptionLabel.sizeToFit()
        descriptionLabel.layout(
            left: SpecMargins.contentSidePadding,
            right: bounds.width - SpecMargins.contentSidePadding,
            top: titleLabel.bottom + 15,
            height: descriptionLabel.height)
    }
    
    // MARK: Private
    private func setupStyle() {
        backgroundColor = UIColor.drcWhite
        
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.textColor = UIColor.drcSlate
        titleLabel.font = SpecFonts.ralewaySemiBold(16)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        descriptionLabel.textColor = UIColor.drcCoolGrey
        descriptionLabel.font = SpecFonts.ralewayMedium(14)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
    }
    
    private func setEmptyDataStyle(_ emptyDataStyle: EmptyDataStyle) {
        imageView.image = emptyDataStyle.style.image
        titleLabel.text = emptyDataStyle.style.title
        descriptionLabel.text = emptyDataStyle.style.description
        
        setNeedsLayout()
    }
}
