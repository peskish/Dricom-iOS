import UIKit

private struct TrackedView {
    weak var weakView: UIView?
}

private enum FirstResponderViewTracking {
    case readyToTrack
    case tracking(TrackedView)
    case discarded(TrackedView)
}

public final class ScrollViewKeyboardAvoidingServiceImpl: ScrollViewKeyboardAvoidingService {
    // MARK: - Public vars
    
    public var defaultAnimationDuration: TimeInterval = 0.1
    public var spacingBetweenFirstResponderAndScrollView: CGFloat = 16
    
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            if contentInset != oldValue {
                if let scrollView = scrollView {
                    let keyboardRect = keyboardFrameService.keyboardFrameInView(scrollView)
                    let scrollViewRect = scrollView.bounds
                    let intersectionHeight = scrollViewRect.intersectionOrNil(keyboardRect)?.size.height ?? 0
                    
                    var actualInsets = contentInset
                    actualInsets.bottom = max(actualInsets.bottom, intersectionHeight)
                    
                    contentInsetOutput?.contentInset = actualInsets
                }
            }
        }
    }
    
    // MARK: - Private vars
    
    private var contentInsetOutput: ContentInsetHolder?
    
    private var combinedKeyboardAvoidingSettingsObservable: CombinedKeyboardAvoidingSettingsObservable? {
        didSet {
            oldValue?.onChange = nil
            combinedKeyboardAvoidingSettingsObservable?.onChange = { [weak self] in
                self?.updateOffsetsAnimated()
            }
        }
    }
    private var firstResponderViewTracking: FirstResponderViewTracking = .readyToTrack
    
    private weak var scrollView: UIScrollView? {
        didSet {
            scrollViewKvo.object = scrollView
        }
    }
    
    // MARK: - Private properties
    private let scrollViewKvo: KeyValueObserver
    private let keyboardFrameService: KeyboardFrameService
    
    // MARK: - Init
    
    public init(
        scrollViewKvo: KeyValueObserver = KeyValueObserver(),
        keyboardFrameService: KeyboardFrameService = KeyboardFrameService())
    {
        self.scrollViewKvo = scrollViewKvo
        self.keyboardFrameService = keyboardFrameService
        
        scrollViewKvo.setObserver(
            { [weak self] _ in
                self?.updateOffsetsAnimated()
            },
            keyPath: "contentSize"
        )
        keyboardFrameService.addObserver(
            object: self,
            onKeyboardFrameWillChange: { [weak self] change in
                change.animateChange {
                    self?.updateOffsets()
                }
            },
            onKeyboardFrameDidChange: { [weak self] _ in
                self?.onKeyboardFrameDidChange()
            }
        )
        scrollViewKvo.setObserver(
            { [weak self] _ in
                if let scrollView = self?.scrollView, scrollView.isDragging {
                    self?.onScrollViewIsDragged()
                }
            },
            keyPath: "pan.state"
        )
    }
    
    // MARK: - ScrollViewKeyboardAvoidingService
    
    public func attachToScrollView(_ scrollView: UIScrollView, contentInsetOutput: ContentInsetHolder) {
        self.scrollView = scrollView
        self.contentInsetOutput = contentInsetOutput
    }
    
    // MARK: - Private
    
    private func fitFrameToBeVisible(_ frameToBeVisible: CGRect, inRect destinationRect: CGRect) -> CGRect {
        var frameToBeVisible = frameToBeVisible
        
        // Moving rules by priority (from lower to higher)
        // 1. Move first responder view down (this may move it beneath keyboard even if it wasn't beneath it)
        frameToBeVisible = rectByMovingRect(frameToBeVisible, downIntoRect: destinationRect)
        
        // 2. Move first responder view over keyboard. This can due to moving it's top outside visible area (if it's bigger than visible area)
        // But we don't care, because it's better to place view over keyboard than fit into visible area.
        frameToBeVisible = rectByMovingRect(frameToBeVisible, upIntoRect: destinationRect)
        
        return frameToBeVisible
    }
    
    private func rectByMovingRect(_ targetRect: CGRect, downIntoRect destinationRect: CGRect) -> CGRect {
        var targetRect = targetRect
        
        let targetRectTop = targetRect.minY // move this
        let destinationRectTop = destinationRect.minY // under this
        
        let offsetToMoveRectDown = destinationRectTop - targetRectTop
        
        let willBeMovedDown = offsetToMoveRectDown > 0 // otherwise it is up, not down
        if willBeMovedDown {
            targetRect.origin.y += offsetToMoveRectDown
        }
        
        return targetRect
    }
    
    private func rectByMovingRect(_ targetRect: CGRect, upIntoRect destinationRect: CGRect) -> CGRect {
        var targetRect = targetRect
        
        let targetRectBottom = targetRect.maxY // move this
        let destinationRectBottom = destinationRect.maxY // above this
        
        let offsetToMoveRectUp = targetRectBottom - destinationRectBottom
        
        let willBeMovedDown = offsetToMoveRectUp > 0; // otherwise it is down, not up
        if willBeMovedDown {
            targetRect.origin.y -= offsetToMoveRectUp
        }
        
        return targetRect
    }
    
    private func onScrollViewIsDragged() {
        // When scroll view is dragged, tracking is stopped
        // So user can drag scroll view and keyboard avoiding service will not scroll him back
        // to current first responder view. It fixes bug on iOS 10 and also can be useful on previous
        // versions, because it is more like and improvement than the kludge.
        //
        // This fixes AI-3680, the bug is reproduced since iOS 10.
        // When keyboardDismissMode is onDrag (for example), if user drags scrollview,
        // first responder is still first responder until some moment (I dunno exactly, but
        // it seems that first responder isn't resigned till dragging or decelerating ends)
        // So, it seems that this logic appeared in iOS 10, and app worked fine on previous iOS versions.
        
        discardTrackingOfFirstResponder()
    }
    
    private func onKeyboardFrameDidChange() {
        // 1. When text input is tapped, keyboard avoiding occures and scroll view scrolls
        // 2. Then, when text input with other keyboard avoiding settings is tapped, keyboard
        // avoiding occures and scroll view scrolls
        //
        // And this is okay.
        //
        // But when keyboard is opening (few fractions of second) after step 1, if step 2
        // occures before it is fully opened, then "scrolling part" of step 2 doesn't occur.
        // This line fixes that (I don't want to figure out why it happens, I already has forgotten
        // how this service tracks change of first responder, I just want to fix this issue):
        //
        // updateOffsetsAnimated()
        //
        // But then I thought that it can make other bugs, so I will restrict this case:
        
        if let firstResponderView = scrollView?.findFirstResponderView() {
            switch firstResponderViewTracking {
            case .tracking(let trackedView):
                if trackedView.weakView !== firstResponderView {
                    updateOffsetsAnimated()
                }
            default:
                break
            }
            
        }
    }
    
    private func updateOffsetsAnimated() {
        UIView.animate(withDuration: defaultAnimationDuration, animations: {
            self.updateOffsets()
        })
    }
    
    private func updateOffsets() {
        // if scrollViewSuperview is nil, we shouldn't change anything. If view is invisible, it isn't intersected with keyboard
        if let scrollView = scrollView, let scrollViewSuperview = scrollView.superview {
            let keyboardRect = keyboardFrameService.nextKeyboardFrameInView(scrollViewSuperview)
            let scrollViewRect = scrollView.frame
            let intersectionSize = scrollViewRect.intersectionOrNil(keyboardRect)?.size ?? CGSize.zero
            
            let keyboardIsVisible = intersectionSize.width > 0 && intersectionSize.height > 0
            
            var contentOffset = scrollView.contentOffset
            var contentInset = self.contentInset
            
            let keyboardInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: intersectionSize.height,
                right: 0
            )
            
            contentInset.bottom = max(contentInset.bottom, intersectionSize.height)
            
            if scrollView.isDragging {
                onScrollViewIsDragged()
            }
            
            if keyboardIsVisible {
                scrollToFitFirstResponderView(
                    scrollView: scrollView,
                    scrollViewSuperview: scrollViewSuperview,
                    keyboardInsets: keyboardInsets,
                    contentOffset: &contentOffset
                )
            } else {
                resetTrackingOfFirstResponder()
            }
            
            // After fitting first responder we may create a "gap", an "impossible" situation for
            // UIScrollView. E.g.: if you drag scroll view to the bottom and try to drag below the bottom,
            // the scroll view will automatically scroll down. But scroll view will not automatically
            // scroll down if we set content offset programmatically.
            //
            //   C
            //   O
            //   N            C
            // +---+        +---+
            // | E |        | N |
            // | N |   ->   | T |
            // | T |        | E |
            // |   |        | N |
            // |   |        | T |
            // +---+        +---+
            //
            // So we must adjust contentOffset and contentInset:
            //
            scrollIfThereIsAGap(
                scrollView: scrollView,
                contentOffset: &contentOffset,
                contentInset: &contentInset,
                keyboardIsVisible: keyboardIsVisible
            )
            
            contentInsetOutput?.contentInset = contentInset
            scrollView.contentOffset = contentOffset
        }
    }
    
    private func defaultRectForFirstResponder(_ firstResponderView: UIView, scrollViewSuperview: UIView) -> CGRect {
        return firstResponderView.convert(firstResponderView.bounds, to: scrollViewSuperview)
    }
    
    // MARK: -
    
    private func scrollToFitFirstResponderView(
        scrollView: UIScrollView,
        scrollViewSuperview: UIView,
        keyboardInsets: UIEdgeInsets,
        contentOffset: inout CGPoint)
    {
        if let firstResponderView = scrollView.findFirstResponderView(), trackView(firstResponderView: firstResponderView) {
            // Should
            
            let frameToBeVisible: CGRect
            
            var insets = contentInset
            
            let spacingInsets = UIEdgeInsets(
                top: spacingBetweenFirstResponderAndScrollView,
                left: 0,
                bottom: spacingBetweenFirstResponderAndScrollView,
                right: 0
            )
            
            insets.top += spacingInsets.top
            insets.bottom += spacingInsets.bottom
            
            let targetAreaForFirstResponderInScrollView = scrollView.frame.shrinked(spacingInsets).shrinked(keyboardInsets)
            var targetAreaForFirstResponder = targetAreaForFirstResponderInScrollView
            
            if let firstResponderSettingsManager = FirstResponderSettingsManager(view: firstResponderView) {
                if let combinedKeyboardAvoidingSettings = firstResponderSettingsManager.combinedKeyboardAvoidingSettings() {
                    if let rectForContent = combinedKeyboardAvoidingSettings.rectForContent?.rect {
                        targetAreaForFirstResponder = scrollViewSuperview
                            .convert(rectForContent, from: nil)
                            .shrinked(spacingInsets)
                            .intersectionOrNil(targetAreaForFirstResponderInScrollView) ?? CGRect.zero
                    }
                    
                    let availableSize = targetAreaForFirstResponder.size
                    
                    if let rect = combinedKeyboardAvoidingSettings.contentFittingFunction.function(availableSize.height)?.rect {
                        frameToBeVisible = scrollViewSuperview.convert(rect, from: nil)
                    } else {
                        frameToBeVisible = defaultRectForFirstResponder(firstResponderView, scrollViewSuperview: scrollViewSuperview)
                    }
                    
                    combinedKeyboardAvoidingSettingsObservable = combinedKeyboardAvoidingSettings.observable
                } else {
                    frameToBeVisible = defaultRectForFirstResponder(firstResponderView, scrollViewSuperview: scrollViewSuperview)
                }
                
            } else {
                frameToBeVisible = defaultRectForFirstResponder(firstResponderView, scrollViewSuperview: scrollViewSuperview)
            }
            
            let frameToBeVisibleOffsetRect = fitFrameToBeVisible(frameToBeVisible, inRect: targetAreaForFirstResponder)
            
            contentOffset.y += frameToBeVisible.origin.y - frameToBeVisibleOffsetRect.origin.y
        }
    }
    
    private func scrollIfThereIsAGap(scrollView: UIScrollView, contentOffset: inout CGPoint, contentInset: inout UIEdgeInsets, keyboardIsVisible: Bool) {
        let topContentOffset = CGPoint(
            x: 0,
            y: -contentInset.top
        )
        let bottomContentOffset = CGPoint(
            x: 0,
            y: scrollView.contentSize.height - scrollView.frame.size.height + contentInset.bottom
        )
        
        var additionalBottomInset: CGFloat = 0
        
        if (topContentOffset.y > bottomContentOffset.y) {
            // Content size is smaller than area for contents, always attach to bottom
            contentOffset = topContentOffset
        } else {
            if (contentOffset.y < topContentOffset.y) {
                // There's a gap at top, attach to top
                contentOffset = topContentOffset
            } else if (contentOffset.y > bottomContentOffset.y) {
                // There's a gap at bottom, add inset for the gap
                additionalBottomInset = contentOffset.y - bottomContentOffset.y
            } else {
                // There's no gap
            }
        }
        
        if keyboardIsVisible {
            contentInset.bottom += additionalBottomInset
        } else {
            contentOffset.y -= additionalBottomInset
        }
    }
    
    // MARK: - First responder tracking
    
    private func discardTrackingOfFirstResponder() {
        switch firstResponderViewTracking {
        case .discarded:
            break
        case .readyToTrack:
            break
        case .tracking(let trackedView):
            firstResponderViewTracking = .discarded(trackedView)
        }
    }
    
    private func resetTrackingOfFirstResponder() {
        firstResponderViewTracking = .readyToTrack
    }
    
    // Start or continue tracking view.
    // Returns true if tracking will be occured
    // Returns false if tracking is discarded for the view
    func trackView(firstResponderView: UIView) -> Bool {
        switch firstResponderViewTracking {
        case .discarded(let trackedView):
            if trackedView.weakView === firstResponderView {
                return false
            } else {
                firstResponderViewTracking = .tracking(
                    TrackedView(weakView: firstResponderView)
                )
                return true
            }
        case .readyToTrack, .tracking:
            firstResponderViewTracking = .tracking(
                TrackedView(weakView: firstResponderView)
            )
            return true
        }
    }
}
