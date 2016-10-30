import UIKit

final class CrossFadePushTransition: ViewControllerTransition {
    func animate(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        duration: TimeInterval,
        completion: (() -> ())? )
    {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock(completion)
        
        let transition: CATransition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        fromViewController.navigationController?.view.layer.add(transition, forKey: "segue")
        
        fromViewController.navigationController?.pushViewController(toViewController, animated: false)
        
        CATransaction.commit()
    }
}
