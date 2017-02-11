import UIKit

// Doesn't manage keyboard
public final class BypassingKeyboardAvoidingService: ScrollViewKeyboardAvoidingService {
    public var contentInset: UIEdgeInsets {
        get {
            return contentInsetOutput?.contentInset ?? contentInsetForFallback
        }
        set {
            contentInsetForFallback = newValue
            contentInsetOutput?.contentInset = newValue
        }
    }
    
    public init() {
    }
    
    private var contentInsetOutput: ContentInsetHolder?
    private weak var scrollView: UIScrollView?
    
    // In case of contentInsetHolder become nil
    private var contentInsetForFallback: UIEdgeInsets = .zero
    
    public func attachToScrollView(_ scrollView: UIScrollView, contentInsetOutput: ContentInsetHolder) {
        self.scrollView = scrollView
        self.contentInsetOutput = contentInsetOutput
    }
}
