import UIKit

public final class CommonPollingService: NSObject, PollingService {
    public typealias PollingAction = () -> ()
    
    // MARK: - Private properties
    private let pollingInterval: TimeInterval
    private let pollingAction: PollingAction
    
    // MARK: - State
    private var pollingTimer: NativeTimer? {
        didSet {
            if oldValue !== pollingTimer {
                oldValue?.cancel()
            }
        }
    }
    
    private var shouldRestartOnApplicationDidBecomeActive: Bool
    
    // MARK: - Init
    public init(
        pollingInterval: TimeInterval,
        shouldStartPollingAndFireOnInitialApplicationActivation: Bool,
        pollingAction: @escaping PollingAction)
    {
        self.pollingInterval = pollingInterval
        self.pollingAction = pollingAction
        self.shouldRestartOnApplicationDidBecomeActive = shouldStartPollingAndFireOnInitialApplicationActivation
        
        super.init()
        
        subscribeToNotifications()
    }
    
    deinit {
        stopPolling()
        unsubscribeFromNotifications()
    }
    
    // MARK: - Private
    private func schedulePollingTimer() {
        pollingTimer = NativeTimer(
            onTick: { [weak self] in
                self?.pollingAction()
            }
        )
        pollingTimer?.timeInterval = pollingInterval
    }
    
    private func subscribeToNotifications() {
        let application = UIApplication.shared
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onAppWillResignActive(_:)),
            name: .UIApplicationWillResignActive,
            object: application
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onAppDidBecomeActive(_:)),
            name: .UIApplicationDidBecomeActive,
            object: application
        )
    }
    
    private func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func onAppWillResignActive(_ sender: NSNotification) {
        if pollingTimer != nil {
            shouldRestartOnApplicationDidBecomeActive = true
        }
        stopPolling()
    }
    
    @objc private func onAppDidBecomeActive(_ sender: NSNotification) {
        if shouldRestartOnApplicationDidBecomeActive {
            pollingAction()
            startPolling()
        }
        shouldRestartOnApplicationDidBecomeActive = false
    }
    
    // MARK: - PollingService
    public func startPolling() {
        if pollingTimer == nil {
            schedulePollingTimer()
        }
    }
    
    public func stopPolling() {
        pollingTimer = nil
    }
    
    public func fireImmediately() {
        pollingAction()
        
        if pollingTimer != nil {
            restartPolling()
        }
    }
}
