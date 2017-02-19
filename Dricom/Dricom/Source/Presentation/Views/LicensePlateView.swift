import UIKit

struct LicenseParts {
    let firstLetter: String
    let numberPart: String
    let restLetters: String
    let regionCode: String
    let countryCode: String
    
    init?(licenseNumber: String?) {
        guard let licenseNumber = licenseNumber, licenseNumber.characters.count >= 7 else {
            return nil
        }
        
        firstLetter = (licenseNumber as NSString).substring(to: 1) + " "
        numberPart = (licenseNumber as NSString).substring(
            with: NSRange(location: 1, length: 3)
        )
        restLetters = " " + (licenseNumber as NSString).substring(
            with: NSRange(location: 4, length: 2)
        )
        regionCode = (licenseNumber as NSString).substring(from: 6)
        countryCode = "RUS"
    }
}

final class LicensePlateView: UIView {
    // MARK: Properties
    private let divider = UIView()
    private let license = UILabel()
    private let regionCode = UILabel()
    private let country = UILabel()
    private let flag = UIImageView(image: #imageLiteral(resourceName: "RUS"))
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        addSubview(divider)
        addSubview(license)
        addSubview(regionCode)
        addSubview(country)
        addSubview(flag)
        
        setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 220, height: 57)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        divider.layout(
            top: bounds.top,
            bottom: bounds.bottom,
            right: bounds.right - 60,
            width: 1
        )
        
        license.layout(
            left: bounds.left + 15,
            right: divider.left - 14,
            top: bounds.top + 8,
            bottom: bounds.bottom - 8
        )
        
        regionCode.layout(
            left: divider.right + 9,
            right: bounds.right - 11,
            top: bounds.top + 11,
            height: 29
        )
        
        flag.size = #imageLiteral(resourceName: "RUS").size
        flag.right = regionCode.right
        flag.top = regionCode.bottom
        
        country.layout(
            left: regionCode.left,
            right: flag.left - 2,
            top: regionCode.bottom,
            height: flag.height
        )
    }
    
    // MARK: - Public
    func setLicenseParts(_ licenseParts: LicenseParts) {
        // License
        let firstLetterAttributed = NSAttributedString(
            string: licenseParts.firstLetter,
            attributes: licenseLettersStyleAttributes
        )
        let numberPartAttributed = NSAttributedString(
            string: licenseParts.numberPart,
            attributes: licenseNumberStyleAttributes
        )
        let restLettersAttributed = NSAttributedString(
            string: licenseParts.restLetters,
            attributes: licenseLettersStyleAttributes
        )
        let licenseAttributed = NSMutableAttributedString(attributedString: firstLetterAttributed)
        licenseAttributed.append(numberPartAttributed)
        licenseAttributed.append(restLettersAttributed)
        license.attributedText = licenseAttributed
        
        // Region
        regionCode.attributedText = NSAttributedString(
            string: licenseParts.regionCode,
            attributes: licenseLettersStyleAttributes
        )
        
        // Country
        country.attributedText = NSAttributedString(
            string: licenseParts.countryCode,
            attributes: countryStyleAttributes
        )
    }
    
    // MARK: - Private
    private func setupStyle() {
        backgroundColor = UIColor.drcWhite
        
        layer.borderColor = UIColor.drcSilver.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 6
        
        divider.backgroundColor = UIColor.drcSilver
        
        license.textAlignment = .center
        
        regionCode.textColor = UIColor.drcSlate
        regionCode.font = UIFont.drcLicenseFont()
        regionCode.textAlignment = .center
        
        country.textColor = UIColor.drcSlate
        country.font = UIFont.drcLicenceCountryFont()
    }
    
    private let licenseLettersStyleAttributes: [String: Any] = {
        return [
            NSForegroundColorAttributeName: UIColor.drcSlate,
            NSFontAttributeName: UIFont.drcLicenseFont() ?? .systemFont(ofSize: 24)
        ]
    }()
    
    private let licenseNumberStyleAttributes: [String: Any] = {
        return [
            NSForegroundColorAttributeName: UIColor.drcSlate,
            NSFontAttributeName: UIFont.drcLicenseNumberFont() ?? .systemFont(ofSize: 24)
        ]
    }()
    
    private let countryStyleAttributes: [String: Any] = {
        return [
            NSForegroundColorAttributeName: UIColor.drcSlate,
            NSFontAttributeName: UIFont.drcLicenceCountryFont() ?? .systemFont(ofSize: 11)
        ]
    }()
}
