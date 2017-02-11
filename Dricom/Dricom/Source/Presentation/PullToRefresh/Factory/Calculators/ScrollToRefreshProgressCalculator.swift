import UIKit

public final class ScrollToRefreshProgressCalculator: ScrollViewRefresherProgressCalculator {
    // MARK: - Init
    public init() {}
    
    // MARK: - ScrollViewRefresherProgressCalculator
    public func calculateRefreshingProgress(_ state: ScrollViewRefresherInterfaceState) -> RefreshingProgress {
        var progress: RefreshingProgress = .none
        
        let refreshControlHeight = state.refreshViewFrame.size.height
        
        if refreshControlHeight > 0 {
            let visibleContentFrame = UIEdgeInsetsInsetRect(state.scrollViewBounds, state.contentInset)
            
            // Content size is greater than visible frame size, and thus control is not always visible.
            // Trigger refresh if control is visible
            if state.contentSize.height >= visibleContentFrame.size.height {
                let visibleRefreshViewFrame = visibleContentFrame.intersectionOrNil(state.refreshViewFrame)
                
                if let visibleRefreshViewFrame = visibleRefreshViewFrame {
                    progress = visibleRefreshViewFrame.size.height > 0 ? .complete : .none
                }
            } else {
                // Content is smaller than visible area and is always visible. Act as pull to refresh.
                
                let frameThatMustBeVisibleToTriggerRefresh: CGRect
                
                switch state.position {
                case .top:
                    frameThatMustBeVisibleToTriggerRefresh = CGRect(x: 0, y: -refreshControlHeight, width: visibleContentFrame.size.width, height: refreshControlHeight)
                case .bottom:
                    frameThatMustBeVisibleToTriggerRefresh = CGRect(x: 0, y: visibleContentFrame.size.height, width: visibleContentFrame.size.width, height: refreshControlHeight)
                }
                
                let visibleFramePart = visibleContentFrame.intersectionOrNil(frameThatMustBeVisibleToTriggerRefresh)
                
                if let visibleFramePart = visibleFramePart {
                    let ratio = Double(visibleFramePart.size.height / refreshControlHeight)
                    
                    if ratio == 1 && !state.isDragging {
                        progress = .complete
                    } else if ratio > 0 {
                        progress = .partial(ratio: ratio)
                    } else {
                        progress = .none
                    }
                }
            }
        }
        
        return progress
    }
}
