import Foundation

public enum RefreshingProgress {
    case none
    case partial(ratio: Double)
    case complete
}
