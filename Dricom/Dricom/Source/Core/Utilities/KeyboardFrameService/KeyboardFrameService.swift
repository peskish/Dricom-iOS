import UIKit

private struct KeyboardFrameObserver {
    weak var object: AnyObject?
    
    var onKeyboardFrameWillChange: ((_ change: KeyboardFrameChange) -> ())?
    var onKeyboardFrameDidChange: ((_ endFrame: CGRect) -> ())?
}

// MARK: -
private class KeyboardFrameObservers {
    private var observers = [KeyboardFrameObserver]()
    
    func allObservers() -> [KeyboardFrameObserver] {
        observers = observers.filter { $0.object != nil }
        return observers
    }
    
    func append(_ observer: KeyboardFrameObserver) {
        if let index = allObservers().index(where: { $0.object === observer.object }) {
            // do not store one observer twice
            observers.remove(at: index)
        }
        observers.append(observer)
    }
}

// MARK: -
public final class KeyboardFrameService: KeyboardFrameProvider {
    private let keyboardFrameObservers = KeyboardFrameObservers()
    
    // Note: Keyboard frames are relative to screen (can be converted from view nil)
    
    // Keyboard frame before and after any animation, or begin frame inside animation
    private var keyboardFrame: CGRect
    
    // Keyboard frame before and after any animation, or end frame inside animation
    private var nextKeyboardFrame: CGRect
    
    // MARK: - Init
    public init() {
        let initialFrame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.size.height,
            width: UIScreen.main.bounds.size.width,
            height: 0
        )
        
        keyboardFrame = initialFrame
        nextKeyboardFrame = initialFrame
        
        startObserving()
    }
    
    deinit {
        stopObserving()
    }
    
    // MARK: - Private
    private func startObserving() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(KeyboardFrameService.onKeyboardWillChangeFrame(_:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector:
            #selector(KeyboardFrameService.onKeyboardDidChangeFrame(_:)),
            name: NSNotification.Name.UIKeyboardDidChangeFrame,
            object: nil
        )
    }
    
    private func stopObserving() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc private func onKeyboardWillChangeFrame(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo,
            let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let keyboardFrameBegin = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardFrameEnd = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let viewAnimationCurveValue = (info[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
            let viewAnimationCurve = UIViewAnimationCurve(rawValue: viewAnimationCurveValue)
        {
            keyboardFrame = keyboardFrameBegin
            nextKeyboardFrame = keyboardFrameEnd
            
            let change = KeyboardFrameChange(
                animationDuration: animationDuration,
                keyboardFrameBegin: keyboardFrameBegin,
                keyboardFrameEnd: keyboardFrameEnd,
                viewAnimationCurve: viewAnimationCurve)
            
            for observer in keyboardFrameObservers.allObservers() {
                observer.onKeyboardFrameWillChange?(change)
            }
        }
    }
    
    @objc private func onKeyboardDidChangeFrame(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo,
            let keyboardFrameEnd = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            keyboardFrame = keyboardFrameEnd
            nextKeyboardFrame = keyboardFrameEnd
            
            for observer in keyboardFrameObservers.allObservers() {
                observer.onKeyboardFrameDidChange?(keyboardFrameEnd)
            }
        }
    }
    
    // MARK: - KeyboardFrameProvider
    
    public func addObserver(
        object: AnyObject,
        onKeyboardFrameWillChange: ((_ change: KeyboardFrameChange) -> ())?,
        onKeyboardFrameDidChange: ((_ endFrame: CGRect) -> ())?)
    {
        let observer = KeyboardFrameObserver(
            object: object,
            onKeyboardFrameWillChange: onKeyboardFrameWillChange,
            onKeyboardFrameDidChange: onKeyboardFrameDidChange
        )
        
        keyboardFrameObservers.append(observer)
    }
    
    public func keyboardFrameInView(_ view: UIView) -> CGRect {
        return view.convert(keyboardFrame, from: nil)
    }
    
    public func nextKeyboardFrameInView(_ view: UIView) -> CGRect {
        return view.convert(nextKeyboardFrame, from: nil)
    }
}
