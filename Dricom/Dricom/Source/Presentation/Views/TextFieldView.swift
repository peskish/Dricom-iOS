import UIKit

class TextFieldView: UIView, UITextFieldDelegate, UIToolbarDelegate {
    // MARK: Properties
    private let textField = UITextField()
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        textField.delegate = self
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textFieldDidChangeValue(_:)), for: .editingChanged)
        addSubview(textField)
        
        setStyle()
    }
    
    private func setStyle() {
        backgroundColor = .clear

        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.textColor = SpecColors.InputField.textMain
        textField.backgroundColor = .clear
        textField.layer.borderColor = SpecColors.InputField.stroke.cgColor
        textField.layer.borderWidth = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.layout(
            left: SpecMargins.contentMargin,
            right: bounds.width - SpecMargins.contentMargin,
            top: bounds.top,
            height: SpecMargins.inputFieldHeight
        )
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return isHidden ? CGSize(width: size.width, height: SpecMargins.inputFieldHeight) : .zero
    }
    
    // MARK: - Accessory view support
    private var accessoryView: UIView?
    
    private func doneButtonAccessoryView() -> UIView {
        let accessoryView = DoneButtonAccessoryView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        accessoryView.setDoneButtonTitle("Готово")
        accessoryView.delegate = self
        accessoryView.onDoneTap = { [weak self] in
            self?.textField.resignFirstResponder()
        }
        return accessoryView
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }
    
    // MARK: - UITextFieldDelegate -
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let keyboardType = keyboardType {
            textField.keyboardType = keyboardType
            textField.reloadInputViews()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChangeValue(_ textField: UITextField) {
        onTextChange?(textField.text)
    }
    
    // MARK: - Public
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var onTextChange: ((String?) -> ())?
    
    var placeholder: String? {
        get {
            return textField.attributedPlaceholder?.string
        }
        set {
            textField.attributedPlaceholder = attributedPlaceholderTextFromText(newValue)
        }
    }
    
    var keyboardType: UIKeyboardType? {
        didSet {
            if keyboardType != oldValue {
                if let keyboardType = keyboardType, [.numbersAndPunctuation, .numberPad, .phonePad, .decimalPad].contains(keyboardType) {
                    accessoryView = doneButtonAccessoryView()
                } else {
                    accessoryView = nil
                }
                textField.inputAccessoryView = accessoryView
                textField.reloadInputViews()
            }
        }
    }
    
    // MARK: Private
    private func attributedPlaceholderTextFromText(_ text: String?) -> NSAttributedString {
        var attributes = [String: AnyObject]()
        attributes[NSForegroundColorAttributeName] = SpecColors.InputField.placeholder
        return NSAttributedString(string: text ?? "", attributes: attributes)
    }
}
