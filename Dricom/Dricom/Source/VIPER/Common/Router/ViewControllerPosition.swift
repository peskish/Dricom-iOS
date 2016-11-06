import UIKit

enum ViewControllerPosition {
    case pushed
    case modal
}

protocol ViewControllerPositionHolder: class {
    var position: ViewControllerPosition? { get set }
}
