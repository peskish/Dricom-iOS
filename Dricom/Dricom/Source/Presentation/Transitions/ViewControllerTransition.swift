import UIKit

protocol ViewControllerTransition {
    func animate(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        duration: TimeInterval,
        completion: (() -> ())?
    )
}

extension ViewControllerTransition {
    func animate(
        from fromViewController: UIViewController,
        to toViewController: UIViewController)
    {
        animate(
            from: fromViewController,
            to: toViewController,
            duration: 0.3,
            completion: nil
        )
    }
    
    func animate(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        completion: (() -> ())? )
    {
        animate(
            from: fromViewController,
            to: toViewController,
            duration: 0.3,
            completion: completion
        )
    }
}
