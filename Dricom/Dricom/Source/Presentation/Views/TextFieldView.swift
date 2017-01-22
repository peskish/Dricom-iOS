import UIKit

enum InputFieldViewState {
    case normal
    case validationError
}

class TextFieldView: UIView, UITextFieldDelegate, UIToolbarDelegate {
    // MARK: Properties
    private let textField = HoshiTextField()
    private let titleLabel = UILabel()
    
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
        
        setStyle()
    }
    
    private func setStyle() {
        backgroundColor = .clear
        
        textField.placeholderColor = .drcSlate
        textField.borderInactiveColor = .drcSilver
        textField.borderActiveColor = .drcSlate
        textField.font = UIFont.drcInputPlaceholderFont()
        textField.placeholderNormalFontScale = 1
        
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
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
        didSet {
            if state != oldValue {
                updateVisibleState()
            }
        }
    }
    
    var isSecureTextEntry: Bool {
        get { return textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    
    func startEditing() {
        guard !textField.isFirstResponder
            else { return }
        
        textField.becomeFirstResponder()
    }
    
    func endEditing() {
        guard textField.isFirstResponder
            else { return }
        
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
            return textField.placeholder
        }
        set {
            textField.placeholder = newValue
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
            textField.borderActiveColor = .drcSlate
        case .validationError:
            textField.borderActiveColor = .red // TODO: style
        }
        
        guard textField.isFirstResponder else { return }
        
        if let text = text, text.isNotEmpty {
            textField.animateViewsForTextDisplay()
        } else {
            textField.animateViewsForTextEntry()
        }
    }
}
