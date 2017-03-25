protocol InputFieldsContainer: class {
    func inputFieldView(field: InputField) -> TextFieldView?
    func allFields() -> [InputField]
}

extension InputFieldsContainer {
    func focusOnField(_ field: InputField?) {
        guard let field = field else { return }
        
        let inputField = inputFieldView(field: field)
        inputField?.startEditing()
    }
    
    func setOnInputChange(field: InputField, onChange: ((String?) -> ())?) {
        let inputField = inputFieldView(field: field)
        inputField?.onTextChange = onChange
    }
    
    func setOnDoneButtonTap(field: InputField, onDoneButtonTap: (() -> ())?) {
        let inputField = inputFieldView(field: field)
        inputField?.onDoneButtonTap = onDoneButtonTap
    }
    
    func setInputPlaceholder(field: InputField, placeholder: String?) {
        let inputField = inputFieldView(field: field)
        inputField?.placeholder = placeholder
    }
    
    func setStateAccordingToErrors(_ errors: [InputFieldError]) {
        allFields().forEach{ field in
            let state: InputFieldViewState = errors.contains(where: { $0.field == field })
                ? .validationError
                : .normal
            
            let inputView = self.inputFieldView(field: field)
            inputView?.state = state
        }
    }
    
    func setState(_ state: InputFieldViewState, to field: InputField) {
        let inputField = inputFieldView(field: field)
        inputField?.state = state
    }
}

protocol InputFieldsContainerHolder: class {
    var inputFieldsContainer: InputFieldsContainer { get }
}

extension InputFieldsContainer where Self: InputFieldsContainerHolder {
    func inputFieldView(field: InputField) -> TextFieldView? {
        return inputFieldsContainer.inputFieldView(field: field)
    }
    
    func allFields() -> [InputField] {
        return inputFieldsContainer.allFields()
    }
}
