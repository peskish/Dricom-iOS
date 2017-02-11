import UIKit

// Inspired by pleasant appearance of Nastya Gorban and her PullToRefresh control
// Code has been rewritten completely.
final public class ScrollViewRefresher {
    public var action: (() -> ())? {
        didSet {
            updateIsEnabledAndSetUp()
        }
    }
    
    public var scrollViewContentInsets: UIEdgeInsets? {
        didSet {
            if scrollViewContentInsets != oldValue {
                updateScrollViewContentInset()
                layoutRefreshView()
                updateIsEnabledAndSetUp()
            }
        }
    }
    
    public var enabled: Bool = true {
        didSet {
            if enabled != oldValue {
                updateIsEnabledAndSetUp()
            }
        }
    }
    
    public private(set) weak var scrollView: UIScrollView? {
        didSet {
            if scrollView != oldValue {
                updateIsEnabledAndSetUp()
            }
        }
    }
    
    public private(set) var isEnabledAndSetUp: Bool = false {
        didSet {
            if isEnabledAndSetUp != oldValue {
                updateProgressIfNeeded()
            }
        }
    }
    
    public private(set) var state: ScrollViewRefresherState = .initial {
        didSet {
            switch state {
            case .loading:
                if let scrollView = scrollView , oldValue != .loading {
                    contentSizeSinceLastLoadingWasTriggeredBeforeGoingToInitialState = scrollView.contentSize
                    scrollView.bounces = false
                    
                    let contentInset: UIEdgeInsets
                    var contentOffset = scrollView.contentOffset
                    scrollViewAdditionalContentInsets = UIEdgeInsets.zero
                    
                    let refreshViewFrame = refreshView.convert(refreshView.bounds, to: scrollView)
                    if refreshViewFrame.origin.y < 0 {
                        let difference = max(0, 0 - refreshViewFrame.origin.y)
                        
                        scrollViewAdditionalContentInsets.top = difference
                        contentInset = scrollViewOverridenContentInsets
                        
                        contentOffset.y = -contentInset.top
                        
                    } else if refreshViewFrame.maxY > scrollView.contentSize.height {
                        let difference = refreshViewFrame.maxY - scrollView.contentSize.height
                        
                        scrollViewAdditionalContentInsets.bottom = difference
                        contentInset = scrollViewOverridenContentInsets
                        
                        contentOffset.y = scrollView.contentSize.height - scrollView.frame.size.height + contentInset.bottom
                    } else {
                        contentInset = scrollViewOverridenContentInsets
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.loadingAnimationClosure({
                            self.animator.animateRefresherState(self.state)
                            
                            self.keyValueObserver.withoutObservingDo {
                                scrollView.contentInset = contentInset
                                scrollView.contentOffset = contentOffset
                            }
                        }, { finished in
                            scrollView.bounces = true
                            
                            self.updateProgressIfNeeded()
                        })
                    })
                    
                    
                    action?()
                }
            case .finished where oldValue != .finished:
                scrollView?.bounces = false
                
                DispatchQueue.main.async(execute: {
                    self.finishingAnimationClosure({
                        self.animator.animateRefresherState(self.state)
                        self.scrollViewAdditionalContentInsets = UIEdgeInsets.zero
                        
                        self.keyValueObserver.withoutObservingDo {
                            self.scrollView?.contentInset = self.scrollViewOverridenContentInsets
                        }
                    }, { finished in
                        self.scrollView?.bounces = true
                        
                        self.updateProgressIfNeeded()
                    })
                })
            case .releasing:
                animator.animateRefresherState(state)
            case .initial:
                contentSizeSinceLastLoadingWasTriggeredBeforeGoingToInitialState = nil
                if oldValue != .initial {
                    animator.animateRefresherState(state)
                }
            default:
                break
            }
        }
    }
    
    private var contentSizeSinceLastLoadingWasTriggeredBeforeGoingToInitialState: CGSize?
    
    // Constants
    private typealias AnimationClosure =  (_ animations: @escaping () -> (), _ completion: ((Bool) -> ())?) -> ()
    
    private static let animationDuration = 0.3
    
    private let loadingAnimationClosure: AnimationClosure = {
        animations, completion in
        
        UIView.animate(withDuration: animationDuration, animations: animations, completion: completion)
    }
    
    private let finishingAnimationClosure: AnimationClosure = {
        animations, completion in
        
        // Spring:
        // UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveLinear, animations: animations, completion: completion)
        
        // Linear:
        //UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: animations, completion: completion)
        
        
        UIView.animate(withDuration: animationDuration, animations: animations, completion: completion)
    }
    
    // Dependencies
    private let animator: ScrollViewRefresherStateAnimator
    private let progressCalculator: ScrollViewRefresherProgressCalculator
    
    private let refreshView: UIView
    private var position: ScrollViewRefresherPosition
    private var scrollViewAdditionalContentInsets = UIEdgeInsets.zero
    
    private var scrollViewOverridenContentInsets: UIEdgeInsets {
        return (scrollViewContentInsets ?? UIEdgeInsets.zero) + scrollViewAdditionalContentInsets
    }
    
    // KVO
    private let keyValueObserver =  KeyValueObserver()
    
    // MARK: - Initialization
    
    public init(
        refreshView: UIView,
        position: ScrollViewRefresherPosition,
        animator: ScrollViewRefresherStateAnimator,
        progressCalculator: ScrollViewRefresherProgressCalculator)
    {
        self.refreshView = refreshView
        self.animator = animator
        self.progressCalculator = progressCalculator
        self.position = position
        
        keyValueObserver.setObserver(
            { [weak self] _ in
                self?.updateProgressIfNeeded()
            },
            keyPath: "contentOffset"
        )
        keyValueObserver.setObserver(
            { [weak self] _ in
                self?.layoutRefreshView()
                self?.updateProgressIfNeeded()
            },
            keyPath: "contentSize"
        )
        keyValueObserver.setObserver(
            { [weak self] _ in
                self?.updateProgressIfNeeded()
            },
            keyPath: "isTracking"
        )
        keyValueObserver.setObserver(
            { [weak self] _ in
                self?.updateProgressIfNeeded()
            },
            keyPath: "isDragging"
        )
    }
    
    deinit {
        keyValueObserver.removeAllObservers()
    }
    
    // MARK: - Public
    
    public func attachToScrollView(_ scrollView: UIScrollView) {
        if self.scrollView != scrollView {
            self.scrollView = scrollView
            
            keyValueObserver.object = scrollView
            
            refreshView.removeFromSuperview()
            scrollView.addSubview(refreshView)
            
            layoutRefreshView()
            updateScrollViewContentInset()
            updateProgressIfNeeded()
        }
    }
    
    public func detachFromScrollView() {
        refreshView.removeFromSuperview()
        keyValueObserver.object = nil
        scrollView = nil
    }
    
    public func startRefreshing() {
        if state == .initial {
            state = .loading
        }
    }
    
    public func endRefreshing() {
        if state == .loading {
            state = .finished
        }
        
        // Uncomment this if state stucks:
        // (this is not right, because if state stucks, there's a bug in other part of code,
        // but simply uncommenting this line may help to reduce frequency of reproduction of the bug)
        //state = .Finished
    }
    
    // MARK: Private
    
    private func updateProgressIfNeeded() {
        if let scrollView = scrollView , isEnabledAndSetUp {
            let interfaceState = ScrollViewRefresherInterfaceState(
                scrollViewBounds: scrollView.bounds,
                refreshViewFrame: refreshView.convert(refreshView.bounds, to: scrollView),
                contentSize: scrollView.contentSize,
                contentOffset: scrollView.contentOffset,
                contentInset: scrollView.contentInset,
                isTracking: scrollView.isTracking,
                isDragging: scrollView.isDragging,
                isDecelerating: scrollView.isDecelerating,
                position: position
            )
            
            let progress = progressCalculator.calculateRefreshingProgress(interfaceState)
            
            handleRefreshingProgressChanged(progress)
        }
    }
    
    private func handleRefreshingProgressChanged(_ progress: RefreshingProgress) {
        switch state {
        case .initial:
            if scrollView?.isDragging == true || scrollView?.isTracking == true {
                switch progress {
                case .none:
                    state = .releasing(progress: 0)
                    break
                case .partial(let ratio):
                    state = .releasing(progress: ratio)
                    break
                case .complete:
                    state = .releasing(progress: 1)
                    break
                }
            } else {
                // Do nothing. Forbid initiating pull to refresh if user does nothing
            }
        case .releasing:
            switch progress {
            case .none:
                if scrollView?.isDragging == true || scrollView?.isTracking == true || scrollView?.isDecelerating == true {
                    state = .releasing(progress: 0)
                } else {
                    state = .initial
                }
            case .partial(let ratio):
                state = .releasing(progress: ratio)
            case .complete:
                if scrollView?.isDragging == true || scrollView?.isTracking == true || scrollView?.isDecelerating == true {
                    state = .loading
                } else {
                    state = .releasing(progress: 1)
                }
            }
        case .finished:
            switch progress {
            case .none:
                // Without this check, user can trigger refresh infinitely by touching and panning scrollview.
                // Steps to reproduce:
                // 1. Disable the check
                // 2. Open any list with paging and load more control (it is at the bottom in the example)
                // 3. Disable internet
                // 4. Go to the bottom of the list
                // 5. Pan the content upper
                // Actual result: infinite triggering of refresh, toasts are shown infinitely
                // (until user stops touching scroll view).
                let userDidNotEndScrolling = scrollView?.isDragging == true || scrollView?.isTracking == true
                
                // There was a bug with the previous check. When content is loaded, and there is an internet connection,
                // user may continue scrolling the list and the previous Bool is true. So it was impossible to
                // trigger load more until user stop scrolling and wait until isTracking become false.
                // And our app lived about a year with this bug. However, we can have a tricky check, if some
                // new page is loaded the content size is changed, so we can transfer to initial state freely.
                // And there will be no bug that was described above the previous variable (userDidNotEndScrolling),
                // because that bug was about the situation with no internet connection. But in case of contentSize
                // is changed we may think that there is an internet connection.
                //
                // The better solution to all problems is
                // 1. Infinite scroll without any toasts on fails.
                // 2. Reachability, reloading the data if needed, and no tries if internet is unreachable.
                // 3. Better UI without current toasts.
                let contentSizeWasChangedAfterRefresh = scrollView?.contentSize != contentSizeSinceLastLoadingWasTriggeredBeforeGoingToInitialState
                
                if userDidNotEndScrolling && !contentSizeWasChangedAfterRefresh {
                    // Prevent infinite triggering of refresh via .initial -> .loading states.
                } else {
                    state = .initial
                }
            case .partial:
                // Do nothing. Wait for progress became zero to initiate new refresh
                break
            case .complete:
                // Do nothing. Wait for progress became zero to initiate new refresh
                break
            }
        case .loading:
            // Don't change state while loading. use `endRefreshing()` to exit this state
            break
        }
    }
    
    private func updateScrollViewContentInset() {
        if let scrollView = scrollView {
            if scrollView.contentInset != scrollViewOverridenContentInsets {
                scrollView.contentInset = scrollViewOverridenContentInsets
            }
        }
    }
    
    private func updateIsEnabledAndSetUp() {
        let setUp = scrollView != nil && scrollViewContentInsets != nil && action != nil
        
        isEnabledAndSetUp = enabled && setUp
    }
    
    private func layoutRefreshView() {
        if let scrollView = scrollView {
            refreshView.frame.size = refreshView.sizeThatFits(
                CGSize(
                    width: scrollView.contentSize.width,
                    height: CGFloat.greatestFiniteMagnitude
                )
            )
            
            refreshView.frame.origin.x = scrollView.bounds.midX - refreshView.frame.size.width / 2
            
            switch position {
            case .top:
                refreshView.frame.origin.y = -refreshView.frame.size.height
            case .bottom:
                let visibleAreaHeight = UIEdgeInsetsInsetRect(scrollView.bounds, scrollViewContentInsets ?? scrollView.contentInset).size.height
                let contentHeight = scrollView.contentSize.height
                
                if contentHeight > visibleAreaHeight {
                    refreshView.frame.origin.y = contentHeight
                } else {
                    refreshView.frame.origin.y = visibleAreaHeight
                }
            }
        }
    }
}
