import UIKit

final class DoneButtonAccessoryView: UIToolbar {
    private let topSeparator = UIView()
    private let bottomSeparator = UIView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        addSubview(topSeparator)
        addSubview(bottomSeparator)
        
        setupAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        topSeparator.layout(
            left: bounds.left,
            right: bounds.right,
            top: bounds.top,
            height: SpecSizes.separatorHeight
        )
        bottomSeparator.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: bounds.bottom,
            height: SpecSizes.separatorHeight
        )
    }
    
    // MARK: Public
    func setDoneButtonTitle(_ title: String) {
        let flexibleLeftSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(DoneButtonAccessoryView.onDoneButtonTap(_:)))
        setItems([flexibleLeftSpaceItem, doneButton], animated: false)
    }
    
    var onDoneTap: (() -> ())?
    
    // MARK: Appearance
    private func setupAppearance() {
        backgroundColor = .white
        isTranslucent = false
        
        topSeparator.backgroundColor = SpecColors.InputField.stroke
        bottomSeparator.backgroundColor = UIColor.black
    }
    
    // MARK: Actions
    @objc private func onDoneButtonTap(_ sender: UIBarButtonItem) {
        onDoneTap?()
    }
}
