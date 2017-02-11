import UIKit

public struct ContentFittingFunction {
    var function: (_ availableHeight: CGFloat) -> ContentFittingRect?
}

public struct ContentFittingCombineFunction {
    var function: (_ currentFunction: ContentFittingFunction, _ subviewFunction: ContentFittingFunction) -> ContentFittingFunction
}
