import UIKit

public struct ScrollViewRefresherInterfaceState {
    public var scrollViewBounds: CGRect
    public var refreshViewFrame: CGRect
    
    public var contentSize: CGSize
    public var contentOffset: CGPoint
    public var contentInset: UIEdgeInsets
    
    public var isTracking: Bool
    public var isDragging: Bool
    public var isDecelerating: Bool
    
    public var position: ScrollViewRefresherPosition
    
    public init(
        scrollViewBounds: CGRect,
        refreshViewFrame: CGRect,
        contentSize: CGSize,
        contentOffset: CGPoint,
        contentInset: UIEdgeInsets,
        isTracking: Bool,
        isDragging: Bool,
        isDecelerating: Bool,
        position: ScrollViewRefresherPosition)
    {
        self.scrollViewBounds = scrollViewBounds
        self.refreshViewFrame = refreshViewFrame
        self.contentSize = contentSize
        self.contentOffset = contentOffset
        self.contentInset = contentInset
        self.isTracking = isTracking
        self.isDragging = isDragging
        self.isDecelerating = isDecelerating
        self.position = position
    }
}