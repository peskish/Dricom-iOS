import UIKit

// WARNING: Keyboard Avoiding Service requires automaticallyAdjustsScrollViewInsets to be false

public protocol ScrollViewKeyboardAvoidingService: ContentInsetHolder {
    // Attaches to scrollview. Can modify UIScrollView.
    //
    // ScrollViewKeyboardAvoidingService implements ContentInsetHolder protocol.
    // It acts as input for insets.
    //
    // It can use contentInsetOutput to output insets at any time.
    // E.g.: right after setting contentInset property or when keyboard appears.
    //
    // Because of having input and output you can make a chain of transforming insets.
    // E.g.: initial insets: insets for navbar/tabbar -> keyboard avoiding service ->
    //       -> refresh control -> collection view
    //
    func attachToScrollView(_ scrollView: UIScrollView, contentInsetOutput: ContentInsetHolder)
}

public extension ScrollViewKeyboardAvoidingService {
    func attachToScrollView(_ scrollView: UIScrollView) {
        attachToScrollView(
            scrollView,
            contentInsetOutput: WeakContentInsetHolder(
                contentInsetHolder: scrollView
            )
        )
    }
}
