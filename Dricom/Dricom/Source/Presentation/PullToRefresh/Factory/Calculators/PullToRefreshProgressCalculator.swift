import UIKit

public final class PullToRefreshProgressCalculator: ScrollViewRefresherProgressCalculator {
    // MARK: - Init
    public init() {}
    
    // MARK: - ScrollViewRefresherProgressCalculator
    public func calculateRefreshingProgress(_ state: ScrollViewRefresherInterfaceState) -> RefreshingProgress {
        var progress: RefreshingProgress = .none
        
        let refreshControlHeight = state.refreshViewFrame.size.height
        
        if refreshControlHeight > 0 {
            let visibleContentFrame = UIEdgeInsetsInsetRect(state.scrollViewBounds, state.contentInset)
            let visibleRefreshViewFrame = visibleContentFrame.intersectionOrNil(state.refreshViewFrame)
            
            if let visibleRefreshViewFrame = visibleRefreshViewFrame {
                let ratio = Double(visibleRefreshViewFrame.size.height / refreshControlHeight)
                
                if ratio == 1 && !state.isDragging {
                    progress = .complete
                } else if ratio > 0 {
                    progress = .partial(ratio: ratio)
                } else {
                    progress = .none
                }
            }
        }
        
        return progress
    }
}
