import Foundation

public enum ScrollViewRefresherState: Equatable, CustomStringConvertible {
    case initial
    case releasing(progress: Double)
    case loading
    case finished
    
    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .initial: return "Initial"
        case .releasing(let progress): return "Releasing: \(progress)"
        case .loading: return "Loading"
        case .finished: return "Finished"
        }
    }
}

public func ==(a: ScrollViewRefresherState, b: ScrollViewRefresherState) -> Bool {
    switch (a, b) {
    case (.initial, .initial), (.loading, .loading), (.finished, .finished):
        return true
    case (.releasing(let a), .releasing(let b)):
        return a == b
    default:
        return false
    }
}
