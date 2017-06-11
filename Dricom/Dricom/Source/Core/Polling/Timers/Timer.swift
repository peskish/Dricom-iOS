import Foundation

public protocol Timer {
    var onTick: () -> () { get set }
    
    // If nil, timer isn't set up and doesn't work.
    var timeInterval: TimeInterval? { get set }
    
    // If nil, default value is used. Value is unspecified.
    var tolerance: TimeInterval? { get set }
    
    // Adjust fire date if timer is setup, do nothing otherwise
    func setFireDate(_ fireDate: Date)
    
    // Cancel timer
    func cancel()
}
