import UIKit

protocol FeedbackAssembly: class {
    func module(
        configure: (_ module: FeedbackModule) -> ())
        -> UIViewController
}
