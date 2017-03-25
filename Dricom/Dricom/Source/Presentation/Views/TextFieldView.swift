import UIKit

enum InputFieldViewState {
    case normal
    case validationError
}

class TextFieldView: UIView, UITextFieldDelegate, UIToolbarDelegate {
    // MARK: Properties
    private let textField = HoshiTextField()
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        textField.delegate = self
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textFieldDidChangeValue(_:)), for: .editingChanged)
        addSubview(textField)
        
        updateStyle()
    }
    
    private func updateStyle() {
        backgroundColor = .clear
        
        textField.placeholderNormalFontScale = 1
        textField.placeholderEditingFontScale = 0.75
        textField.font = UIFont.drcInputPlaceholderFont()
        textField.borderInactiveColor = .drcSilver
        
        if isEnabled {
            textField.placeholderColor = .drcSlate
            textField.borderActiveColor = .drcSlate
            textField.textColor = .drcSlate
        } else {
            textField.placeholderColor = .drcSilver
            textField.borderActiveColor = .drcSilver
            textField.textColor = .drcSilver
        }
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
            height: SpecSizes.inputFieldHeight
        )
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return isHidden ? CGSize(width: size.width, height: SpecSizes.inputFieldHeight) : .zero
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
    
    var isEnabled: Bool = true {
        didSet {
            if isEnabled != oldValue {
                if !isEnabled && textField.isFirstResponder {
                    textField.resignFirstResponder()
                }
                
                isUserInteractionEnabled = isEnabled
                
                updateVisibleState()
                updateStyle()
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
        if isEnabled {
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
        } else {
            textField.borderActiveColor = .clear
        }
    }
}
