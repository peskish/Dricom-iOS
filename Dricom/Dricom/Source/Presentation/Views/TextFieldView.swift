import UIKit

enum InputFieldViewState {
    case normal
    case validationError
}

class TextFieldView: UIView, UITextFieldDelegate, UIToolbarDelegate {
    // MARK: Properties
    private let textField = InputTextField()
    private let titleLabel = UILabel()
    private let placeholderLabel = UILabel()
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        textField.delegate = self
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChangeValue(_:)), for: .editingChanged)
        addSubview(textField)
        
        titleLabel.alpha = 0
        addSubview(titleLabel)
        addSubview(placeholderLabel)
        
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
        
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        placeholderLabel.backgroundColor = .clear
        placeholderLabel.textColor = SpecColors.InputField.placeholder
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
        
        titleLabel.sizeToFit()
        titleLabel.top = textField.top + 2
        titleLabel.left = textField.left + SpecMargins.innerContentMargin
        
        placeholderLabel.layout(
            left: textField.left + SpecMargins.innerContentMargin,
            right: textField.right - SpecMargins.innerContentMargin,
            top: textField.top,
            bottom: textField.bottom
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
    
    // MARK: - Private
    private var isTextEmpty: Bool {
        return textField.text?.isEmpty == true 
    }
    
    private func animateBeginTextEntering() {
        titleLabel.centerY = textField.centerY
        titleLabel.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.alpha = 1
            self.titleLabel.top = self.textField.top + 2
            self.placeholderLabel.alpha = 0
        }
    }
    
    private func animateEndTextEntering() {
        UIView.animate(withDuration: 0.2) {
            self.placeholderLabel.alpha = 1
            self.titleLabel.centerY = self.textField.centerY
            self.titleLabel.alpha = 0
        }
    }
    
    // MARK: - UITextFieldDelegate -
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let keyboardType = keyboardType {
            textField.keyboardType = keyboardType
            textField.reloadInputViews()
        }
        
        if isTextEmpty {
            animateBeginTextEntering()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isTextEmpty {
            animateEndTextEntering()
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
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
            titleLabel.text = newValue
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
            top: SpecMargins.inputFieldTitleHeight,
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
