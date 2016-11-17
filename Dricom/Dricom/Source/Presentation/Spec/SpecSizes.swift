import UIKit

final class SpecSizes {
    static let scale = UIScreen.main.scale
    
    static let minimumButtonArea = CGSize(width: 44, height: 44)
    static let separatorHeight: CGFloat = 1 / UIScreen.main.scale
    static let statusBarHeight: CGFloat = 20
    static let bottomAreaHeight: CGFloat = 44
    static let socialFeedbackButtonSize = CGSize(width: 60, height: 60)
    static let avatarImageSize = CGSize(width: 102*scale, height: 102*scale)
}
