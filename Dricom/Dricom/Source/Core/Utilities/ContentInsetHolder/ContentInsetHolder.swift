import UIKit

public protocol ContentInsetHolder: class {
    /// E.g.:
    ///
    /// override func viewWillLayoutSubviews() {
    ///     super.viewWillLayoutSubviews()
    ///
    ///     publishParametersView.contentInset = UIEdgeInsets(
    ///         top: topLayoutGuide.length,
    ///         left: 0,
    ///         bottom: bottomLayoutGuide.length,
    ///         right: 0
    ///     )
    /// }
    var contentInset: UIEdgeInsets { get set }
}

public final class WeakContentInsetHolder: ContentInsetHolder {
    private weak var contentInsetHolder: ContentInsetHolder?
    
    public init(contentInsetHolder: ContentInsetHolder) {
        self.contentInsetHolder = contentInsetHolder
        contentInsetForFallback = contentInsetHolder.contentInset
    }
    
    // In case of contentInsetHolder become nil
    private var contentInsetForFallback: UIEdgeInsets
    
    public var contentInset: UIEdgeInsets {
        get {
            return contentInsetHolder?.contentInset ?? contentInsetForFallback
        }
        set {
            contentInsetForFallback = newValue
            contentInsetHolder?.contentInset = newValue
        }
    }
}

extension UIScrollView: ContentInsetHolder {
}
