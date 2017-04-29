// 1--------2---------3--4-5-6---789-----0--------------
// ^delay\  ^delay\
// -------1--------2---------3--4-5-6---789-----0-------
//
// http://rxmarbles.com/#delay
//
// Real life example:
//
// showLoader()hideLoader()-------showLoader()-------------------------------hideLoader()
// ^==========delay==========\    ^==========delay==========\
// -----user-sees-nothing-----------------------------------|user sees loader|------
import Foundation

public final class Delayer {
    // MARK: - Private properties
    private let queue: DispatchQueue
    private let delayTime: TimeInterval
    
    // MARK: - Init
    public init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main ) {
        assert(delay >= 0, "Delayer can't have negative delay")
        
        self.delayTime = delay
        self.queue = queue
    }
    
    // MARK: - Public
    public func delay(_ closure: @escaping () -> ()) {
        if delayTime > 0 {
            queue.asyncAfter(deadline: .now() + delayTime) {
                closure()
            }
        } else {
            closure()
        }
    }
}
