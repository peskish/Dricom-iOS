// 1--------2----3--4-5-6---789-----0
// ^delay]  ^delay] ^delay] ^delay]
// 1--------2-------4-------7-------0
//
// Real life example:
//
// Error!-Error!-Error!------------Error!-Error!--------------
// ^====throttling===delay===.     ^====throttling===delay===.
// Error!--------------------------Error!---------------------
import Foundation

public final class Throttler {
    // MARK: - Public properite
    public let delay: TimeInterval
    
    // MARK: - Private properite
    private var lastFireTime: DispatchTime
    
    // MARK: - Init
    public init(delay: TimeInterval) {
        assert(delay >= 0, "Throttler can't have negative delay")
        
        self.delay = delay
        self.lastFireTime = DispatchTime.now() - delay
    }
    
    // MARK: - Public
    public func throttle(_ closure: () -> ()) {
        let now = DispatchTime.now()
        let when = lastFireTime + delay
        if now >= when {
            fire(closure)
        }
    }
    
    // MARK: - Private
    private func fire(_ closure: () -> ()) {
        lastFireTime = DispatchTime.now()
        closure()
    }
}
