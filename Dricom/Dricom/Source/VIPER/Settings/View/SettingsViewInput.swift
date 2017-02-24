import Foundation

protocol SettingsViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    func setViewTitle(_ title: String)
}
