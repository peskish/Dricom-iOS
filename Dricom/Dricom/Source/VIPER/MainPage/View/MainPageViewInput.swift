import Foundation

protocol MainPageViewInput: class, ViewLifecycleObservable, MessageDisplayable, ActivityDisplayable {
    func setAvatarImageUrl(_ avatarImageUrl: URL?)
}
