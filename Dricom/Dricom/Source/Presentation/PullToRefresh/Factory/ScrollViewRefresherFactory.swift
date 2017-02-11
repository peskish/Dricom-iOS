import Foundation

public protocol ScrollViewRefresherFactory: class {
    func createLoadMore(position: ScrollViewRefresherPosition) -> ScrollViewRefresher
    func createRefresh(position: ScrollViewRefresherPosition) -> ScrollViewRefresher
}
