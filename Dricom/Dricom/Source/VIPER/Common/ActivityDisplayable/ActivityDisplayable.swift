public protocol ActivityDisplayable: class {
    func startActivity()
    func stopActivity()
}

public final class WeakActivityDisplayable: ActivityDisplayable {
    // MARK: - Private properties
    private weak var activityDisplayable: ActivityDisplayable?
    
    // MARK: - Init
    public init(activityDisplayable: ActivityDisplayable) {
        self.activityDisplayable = activityDisplayable
    }
    
    // MARK: - ActivityDisplayable
    public func startActivity() {
        activityDisplayable?.startActivity()
    }
    
    public func stopActivity() {
        activityDisplayable?.stopActivity()
    }
}
