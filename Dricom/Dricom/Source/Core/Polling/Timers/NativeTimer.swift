import Foundation

public final class NativeTimer: Timer {
    public typealias OnTick = () -> ()
    
    // MARK: - Private properties
    private var nsTimer: Foundation.Timer?
    private let repeats: Bool
    
    // MARK: - Init
    public init(onTick: @escaping OnTick, repeats: Bool = true) {
        self.onTick = onTick
        self.repeats = repeats
    }
    
    // MARK: - Deinit
    deinit {
        nsTimer?.invalidate()
    }
    
    // MARK: - Timer
    public var onTick: OnTick
    
    public var timeInterval: TimeInterval? {
        didSet {
            updateTimerScheduling()
        }
    }
    
    public var tolerance: TimeInterval? {
        didSet {
            updateTimerScheduling()
        }
    }
    
    public func setFireDate(_ fireDate: Date) {
        nsTimer?.fireDate = fireDate
    }
    
    public func cancel() {
        nsTimer?.invalidate()
    }
    
    // MARK: - Private
    private func updateTimerScheduling() {
        if let timeInterval = timeInterval {
            let tolerance = self.tolerance ?? 0
            
            let target = NsTimerTarget(
                onTick: { [weak self] in
                    self?.onTick()
                }
            )
            
            nsTimer?.invalidate()
            nsTimer = Foundation.Timer.scheduledTimer(
                timeInterval: timeInterval,
                target: target,
                selector: target.selector,
                userInfo: nil,
                repeats: repeats
            )
            nsTimer?.tolerance = tolerance
            
        } else {
            nsTimer?.invalidate()
        }
    }
}

// To avoid memory loops by having weak references:
// 1. NSTimer holds this target.
// 2. This target doesn't hold NSTimer.
// 3. The closure can have weak references.
private class NsTimerTarget: NSObject {
    typealias OnTick = () -> ()
    
    var onTick: OnTick
    let selector = #selector(NsTimerTarget.handleNsTimerFired)
    
    init(onTick: @escaping OnTick) {
        self.onTick = onTick
    }
    
    @objc func handleNsTimerFired() {
        onTick()
    }
}
