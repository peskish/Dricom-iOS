import UIKit

class DelegatingContentInsetHolder: ContentInsetHolder {
    private let getter: () -> (UIEdgeInsets)
    private let setter: (UIEdgeInsets) -> ()
    
    var contentInset: UIEdgeInsets {
        get { return getter() }
        set { setter(newValue) }
    }
    
    init(getter: @escaping () -> (UIEdgeInsets), setter: @escaping (UIEdgeInsets) -> ()) {
        self.getter = getter
        self.setter = setter
    }
}
