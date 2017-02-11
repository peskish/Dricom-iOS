import UIKit

// There is no other way to observe keyboard frame changes,
// when UIScrollView's keyboardDismissMode is .Interactive
public final class KeyboardFrameObservingAccessoryView: UIView {
    public weak var delegate: KeyboardFrameObservingAccessoryViewDelegate?
    
    // Returns nil if value is not observed or can not be observed
    private(set) var keyboardFrame: CGRect?
    
    private var kvo = KeyValueObserver()
    
    public init() {
        super.init(frame: CGRect.zero)
        
        isUserInteractionEnabled = false
        
        kvo.setObserver(
            { [weak self] _ in
                self?.handleSuperviewChangedFrame()
            }, keyPath: "frame")
        kvo.setObserver(
            { [weak self] _ in
                self?.handleSuperviewChangedFrame()
            }, keyPath: "center")
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        kvo.object = newSuperview
        super.willMove(toSuperview: newSuperview)
    }
    
    // NOTE: Keyboard height is unknown! (and so bottom is always points to the bottom of the screen)
    private func handleSuperviewChangedFrame() {
        let frameInWindow = convert(bounds, to: nil)
        
        if frameInWindow.isInfinite {
            keyboardFrame = nil
        } else {
            let keyboardFrame = CGRect(left: frameInWindow.left, right: frameInWindow.right, top: frameInWindow.bottom, bottom: UIScreen.main.bounds.bottom)
            self.keyboardFrame = keyboardFrame
            delegate?.keyboardFrameObservingAccessoryView(self, didObserveKeyboardFrameChange: keyboardFrame)
        }
    }
}
