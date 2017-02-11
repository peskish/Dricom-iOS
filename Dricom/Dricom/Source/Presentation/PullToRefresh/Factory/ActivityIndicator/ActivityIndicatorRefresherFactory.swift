import UIKit

public final class ActivityIndicatorRefresherFactory: ScrollViewRefresherFactory {
    
    private let refresherColor: UIColor?
    
    // MARK: - Init
    public init(withRefresherColor refresherColor: UIColor? = nil) {
        self.refresherColor = refresherColor
    }
    
    // MARK: - ScrollViewRefresherFactory
    public func createLoadMore(position: ScrollViewRefresherPosition) -> ScrollViewRefresher {
        let refreshView = createRefreshView()
        refreshView.activityIndicator.color = refresherColor
        let animator = createAnimator(refreshView)
        let progressCalculator = ScrollToRefreshProgressCalculator()
        return ScrollViewRefresher(refreshView: refreshView, position: position, animator: animator, progressCalculator: progressCalculator)
    }
    
    public func createRefresh(position: ScrollViewRefresherPosition) -> ScrollViewRefresher {
        let refreshView = createRefreshView()
        refreshView.activityIndicator.color = refresherColor
        let animator = createAnimator(refreshView)
        let progressCalculator = PullToRefreshProgressCalculator()
        return ScrollViewRefresher(refreshView: refreshView, position: position, animator: animator, progressCalculator: progressCalculator)
    }
    
    // MARK: - Private
    private func createRefreshView() -> ActivityIndicatorRefreshView {
        return ActivityIndicatorRefreshView()
    }
    
    private func createAnimator(_ refreshView: ActivityIndicatorRefreshView) -> ScrollViewRefresherStateAnimator {
        return ActivityIndicatorRefresherStateAnimator(refreshView: refreshView)
    }
    
    private func createProgressCalculator() {
        
    }
}
