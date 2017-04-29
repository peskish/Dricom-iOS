// 1--------2----3--4-5-6---------789-------
// ^delay.  ^dela^de^d^d^delay.   ^^^delay.
// ------1--------------------6-----------9-
//
// http://rxmarbles.com/#debounce
//
// Real life example:
//
// Л-е-с-на--я------------------------------
// ^d^d^d^^de^delay.
// ----------------suggest("Лесная")--------
import Foundation

public final class Debouncer {
    // MARK: - Private properties
    private var lastFireTime = DispatchTime(uptimeNanoseconds: 0)
    private let queue: DispatchQueue
    private let delay: TimeInterval
    
    // MARK: - Init
    public init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }
    
    // MARK: - Public
    public func debounce(_ closure: @escaping () -> ()) {
        lastFireTime = DispatchTime.now()
        queue.asyncAfter(deadline: .now() + delay) { [weak self] in
            if let strongSelf = self {
                let now = DispatchTime.now()
                let when = strongSelf.lastFireTime + strongSelf.delay
                if now >= when {
                    closure()
                }
            }
        }
    }
}
