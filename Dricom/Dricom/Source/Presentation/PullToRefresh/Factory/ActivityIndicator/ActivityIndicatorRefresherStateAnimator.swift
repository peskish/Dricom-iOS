import UIKit

public final class ActivityIndicatorRefresherStateAnimator: ScrollViewRefresherStateAnimator {
    // MARK: - Init
    private let refreshView: ActivityIndicatorRefreshView
    
    public init(refreshView: ActivityIndicatorRefreshView) {
        self.refreshView = refreshView
    }
    
    // MARK: - ScrollViewRefresherStateAnimator
    public func animateRefresherState(_ state: ScrollViewRefresherState) {
        var animating: Bool
        var progress: CGFloat
        
        switch state {
        case .initial:
            progress = 0
            animating = false
        case .finished:
            progress = 0
            animating = false
        case .releasing(let progressAsDouble):
            progress = CGFloat(progressAsDouble)
            animating = false
        case .loading:
            progress = 1
            animating = true
        }
        
        var transform = CGAffineTransform.identity
        
        if (progress > 0 && progress < 1) {
            let fullCircle = CGFloat(M_PI * 2)
            transform = transform.scaledBy(x: progress, y: progress);
            transform = transform.rotated(by: fullCircle * progress);
        }
        
        refreshView.activityIndicator.transform = transform
        
        if animating {
            refreshView.activityIndicator.startAnimating()
        } else {
            refreshView.activityIndicator.stopAnimating()
        }
        
        refreshView.activityIndicator.isHidden = false
        refreshView.activityIndicator.alpha = progress == 0 ? 0 : 1
    }
}
