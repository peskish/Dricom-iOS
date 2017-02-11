import UIKit

public protocol KeyboardFrameObservingAccessoryViewDelegate: class {
    func keyboardFrameObservingAccessoryView(_ view: UIView, didObserveKeyboardFrameChange newFrame: CGRect)
}
