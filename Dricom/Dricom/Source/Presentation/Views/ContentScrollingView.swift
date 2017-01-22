import UIKit

// Note: when keyboard change its frame we use provided animation duration from NSNotification
private let kScrollingContentsDefaultAnimationDuration: TimeInterval = 0.1

class BaseContentScrollingView : UIScrollView {
    var initialInsets: UIEdgeInsets = .zero {
        didSet {
            if initialInsets != oldValue {
                contentInset = initialInsets
                scrollIndicatorInsets = initialInsets
            }
        }
    }
    
    // This enables scrolling after long tap on the nested UIControls
    override func touchesShouldCancel(in view: UIView) -> Bool {
        return view.isKind(of: UIControl.self)
    }
}


// WARNING: There's a bug. If you have ContentScrollingView and push view controller with another ContentScrollingView,
// open a keyboard and pop back, parent ContentScrollingView will calculate its insets not properly.
// However, there's no such case at the moment.
class ContentScrollingView : BaseContentScrollingView {
    // MARK: Properties
    private var presentingKeyboardFrame: CGRect = .zero
    
    override var initialInsets: UIEdgeInsets {
        didSet {
            if initialInsets != oldValue {
                var insets = initialInsets
                let keyboardFrameRelative = superview?.convert(presentingKeyboardFrame, from: nil) ?? .zero
                let height = frame.intersection(keyboardFrameRelative).height
                insets.bottom = max(insets.bottom, height)
                
                contentInset = initialInsets
                scrollIndicatorInsets = initialInsets
            }
        }
    }
    
    override var contentSize: CGSize {
        didSet {
            if contentSize != oldValue {
                // Handle change of the frame of first responder.
                // Coincidentally it can be handled within this method.
                // TODO: also observe change of first responder, because it may be changed without change of self.frame or frame of keyboard
                updateOffsets(animationDuration:0)
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bounces = true
        backgroundColor = .clear
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false
        isDirectionalLockEnabled = true
        
        keyboardDismissMode = .onDrag
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Keyboard events
    @objc func onKeyboardWillChangeFrame(notification: Notification) {
        guard let info = notification.userInfo,
            let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        
        self.presentingKeyboardFrame = keyboardFrame
        
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            ?? kScrollingContentsDefaultAnimationDuration
        
        let animationCurve: UIViewAnimationCurve
        if let rawAnimationCurve = (info[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
            let animationCurveFromNotification = UIViewAnimationCurve(rawValue: rawAnimationCurve) {
            animationCurve = animationCurveFromNotification
        } else {
            animationCurve = .linear
        }
        
        updateOffsets(
            keyboardFrameRelativeToWindow: keyboardFrame,
            duration: animationDuration,
            curve: animationCurve
        )
    }
    
    // MARK: - Private
    private func updateOffsets(animationDuration: TimeInterval) {
        updateOffsets(
            keyboardFrameRelativeToWindow: presentingKeyboardFrame,
            duration: animationDuration,
            curve: .linear
        )
    }
    
    // 1. The method places bottom boundary of first responder view above keyboard.
    // 2. Also it places top boundary inside visible area (which is inset) if it doesn't break rule 1
    // 3. After all it checks if there are unwanted gaps below or above contents and fixes that.
    private func updateOffsets(
        keyboardFrameRelativeToWindow: CGRect,
        duration: TimeInterval,
        curve: UIViewAnimationCurve )
    {
        // Note: all frames are in superview's coordinate system (e.g.: self.frame)
        let keyboardFrame = superview?.convert(keyboardFrameRelativeToWindow, from: nil) ?? .zero
        let intersectionOfSelfAndKeyboard = frame.intersection(keyboardFrame)
        let widthOfKeyboardInSelf = intersectionOfSelfAndKeyboard.width
        let heightOfKeyboardInSelf: CGFloat
        if widthOfKeyboardInSelf > 0 {
            heightOfKeyboardInSelf = intersectionOfSelfAndKeyboard.height
        } else {
            // Keyboard is de-facto invisible.
            heightOfKeyboardInSelf = 0
        }
        
        let keyboardIsVisible = heightOfKeyboardInSelf > 0 && widthOfKeyboardInSelf > 0
        var contentOffset = self.contentOffset
        var contentInset = self.initialInsets
        contentInset.bottom = max(contentInset.bottom, heightOfKeyboardInSelf)
        
        let firstResponderView = UIView.findFirstResponderView(self)
        
        if let firstResponderView = firstResponderView, keyboardIsVisible {
            let firstResponderFrame = superview?.convert(
                firstResponderView.frame,
                from: firstResponderView.superview
            ) ?? .zero
            var insets = contentInset
            insets.top += SpecMargins.innerContentMargin
            insets.bottom += SpecMargins.innerContentMargin
            let targetAreaForFirstResponder = UIEdgeInsetsInsetRect(frame, insets)
            let firstResponderOffsetRect = fitFirstResponderRect(
                firstResponderFrame,
                inRect: targetAreaForFirstResponder
            )
            contentOffset.y += firstResponderFrame.origin.y - firstResponderOffsetRect.origin.y
        }
        
        // Scroll if there's a gap.
        let topContentOffset = CGPoint(x: 0, y: -contentInset.top)
        let bottomContentOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        
        if topContentOffset.y > bottomContentOffset.y {
            // Content size is smaller than area for contents, always attach to bottom
            contentOffset = topContentOffset
        } else {
            if contentOffset.y < topContentOffset.y {
                // There's a gap at top, attach to top
                contentOffset = topContentOffset
            } else if contentOffset.y > bottomContentOffset.y {
                // There's a gap at bottom, attach to bottom
                contentOffset = bottomContentOffset
            } else {
                // There's no gap
            }
        }
        
        if self.contentOffset != contentOffset || self.contentInset != contentInset {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(duration)
            UIView.setAnimationCurve(curve)
            UIView.setAnimationBeginsFromCurrentState(false)
            
            self.contentInset = contentInset
            self.contentOffset = contentOffset
            
            UIView.commitAnimations()
        }
    }

    private func fitFirstResponderRect(_ firstResponderRect: CGRect, inRect destinationRect: CGRect) -> CGRect {
        // Moving rules by priority (from lower to higher)
        // 1. Move first responder view down (this may move it beneath keyboard even if it wasn't beneath it)
        var firstResponderRect = rectByMovingRect(firstResponderRect, downIntoRect: destinationRect)
        
        // 2. Move first responder view over keyboard. This can due to moving it's top outside visible area
        // (if it's bigger than visible area)
        // But we don't care, because it's better to place view over keyboard than fit into visible area.
        firstResponderRect = rectByMovingRect(firstResponderRect, upIntoRect: destinationRect)

        return firstResponderRect
    }
    
    private func rectByMovingRect(_ targetRect: CGRect, downIntoRect destinationRect: CGRect) -> CGRect {
        var targetRect = targetRect
        let targetRectTop = targetRect.minY // move this
        let destinationRectTop = destinationRect.minY // under this
        let offsetToMoveRectDown = destinationRectTop - targetRectTop
        let willBeMovedDown = offsetToMoveRectDown > 0 // otherwise it is up, not down
        if willBeMovedDown {
            targetRect.origin.y += offsetToMoveRectDown
        }
        return targetRect
    }
    
    private func rectByMovingRect(_ targetRect: CGRect, upIntoRect destinationRect: CGRect) -> CGRect {
        var targetRect = targetRect
        let destinationRectBottom = destinationRect.maxY  // above this
        let targetRectBottom = targetRect.maxY  // move this
        let offsetToMoveRectUp = targetRectBottom - destinationRectBottom
        let willBeMovedUp = offsetToMoveRectUp > 0 // otherwise it is down, not up
        if willBeMovedUp {
            targetRect.origin.y -= offsetToMoveRectUp
        }
        return targetRect
    }
}
