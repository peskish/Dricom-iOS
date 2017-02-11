public protocol ScrollViewRefresherProgressCalculator: class {
    func calculateRefreshingProgress(_ state: ScrollViewRefresherInterfaceState) -> RefreshingProgress
}
