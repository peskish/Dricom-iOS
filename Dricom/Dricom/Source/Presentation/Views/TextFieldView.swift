import UIKit

enum InputFieldViewState {
    case normal
    case validationError
}

class TextFieldView: UIView, UITextFieldDelegate, UIToolbarDelegate {
    // MARK: Properties
    private let textField = InputTextField()
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        textField.delegate = self
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
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
        textField.layer.borderWidth = 1
        textField.tintColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.layout(
            left: SpecMargins.contentSidePadding,
            right: bounds.width - SpecMargins.contentSidePadding,
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
            if self?.onDoneButtonTap != nil {
                self?.onDoneButtonTap?()
            } else {
                self?.textField.resignFirstResponder()
            }
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
        if let onDoneButtonTap = onDoneButtonTap {
            onDoneButtonTap()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    @objc func textFieldDidChangeValue(_ textField: UITextField) {
        onTextChange?(textField.text)
    }
    
    // MARK: - Public
    var state: InputFieldViewState = .normal {
        didSet { updateVisibleState() }
    }
    
    var isSecureTextEntry: Bool {
        get { return textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    
    func startEditing() {
        textField.becomeFirstResponder()
    }
    
    func endEditing() {
        textField.resignFirstResponder()
    }
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var onTextChange: ((String?) -> ())?
    
    var onDoneButtonTap: (() -> ())?
    
    var placeholder: String? {
        get {
            return textField.attributedPlaceholder?.string
        }
        set {
            textField.attributedPlaceholder = attributedPlaceholderTextFromText(newValue)
        }
    }
    
    var returnKeyType: UIReturnKeyType {
        get { return textField.returnKeyType }
        set { textField.returnKeyType = newValue }
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
    
    func updateVisibleState() {
        switch state {
        case .normal:
            textField.layer.borderColor = SpecColors.InputField.stroke.cgColor
        case .validationError:
            textField.layer.borderColor = SpecColors.InputField.textInvalid.cgColor
        }
    }
}

private class InputTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.shrinked(
            top: 0,
            left: SpecMargins.innerContentMargin,
            bottom: 0,
            right: SpecMargins.innerContentMargin
        )
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
