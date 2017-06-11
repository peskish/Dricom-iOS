public protocol PollingService {
    func startPolling()
    func stopPolling()
    func fireImmediately() // Runs polling action immediately. Restarts polling if was polling
}

public extension PollingService {
    func restartPolling() {
        stopPolling()
        startPolling()
    }
}
