import UIKit

protocol RegisterViewInput: class, ViewLifecycleObservable, MessageDisplayable, ActivityDisplayable {
    func setAddPhotoTitle(_ title: String)
    func setAddPhotoImage(_ image: UIImage?)
    func setRegisterButtonTitle(_ title: String)
    func setOnInputChange(field: RegisterInputField, onChange: ((String?) -> ())?)
    func setInputPlaceholder(field: RegisterInputField, placeholder: String?)
    func setOnDoneButtonTap(field: RegisterInputField, onDoneButtonTap: (() -> ())?)
    func focusOnField(_ field: RegisterInputField?)
    func setStateAccordingToErrors(_ errors: [RegisterInputFieldError])
    func setState(_ state: InputFieldViewState, to field: RegisterInputField)
    func endEditing()
    
    
    var onAddPhotoButtonTap: (() -> ())? { get set }
    var onRegisterButtonTap: (() -> ())? { get set }
    var onInfoButtonTap: (() -> ())? { get set }
}
