import UIKit

final public class ActivityIndicatorRefreshView: UIView {
    public private(set) var activityIndicator: UIActivityIndicatorView
    
    override public init(frame: CGRect) {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        super.init(frame: frame)
        
        addSubview(activityIndicator)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = size
        size.height = 40
        return size
    }
}
