import UIKit

public final class ContentFittingFunctionBuilder {
    public static func notFitting() -> ContentFittingFunction {
        return ContentFittingFunction { _ in
            return nil
        }
    }
    
    public static func rectRelativeToWindow(_ rectRelativeToWindow: CGRect) -> ContentFittingFunction {
        return ContentFittingFunction { height in
            return ContentFittingRect(
                rectRelativeToWindow: rectRelativeToWindow
            )
        }
    }
    
    public static func boundsOfView(_ view: UIView) -> ContentFittingFunction {
        return ContentFittingFunction { height in
            return ContentFittingRect(
                boundsOfView: view
            )
        }
    }
    
    public static func contentOfScrollView(_ view: UIScrollView) -> ContentFittingFunction {
        return ContentFittingFunction { height in
            return ContentFittingRect(
                contentOfScrollView: view
            )
        }
    }
    
    // Now it is unused, however, if we need to fine tune insets, we can rewrite KeyboardAvoidingService and use this function instead of hardcoded.
    public static func inset(_ contentFittingFunction: ContentFittingFunction, inset: UIEdgeInsets) -> ContentFittingFunction {
        return ContentFittingFunction { availableHeight in
            contentFittingFunction.function(availableHeight).flatMap { contentFittingRect in
                return ContentFittingRect(
                    rectRelativeToWindow: contentFittingRect.rect.extended(inset)
                )
            }
        }
    }
    
    public static func union(_ first: ContentFittingFunction, _ second: ContentFittingFunction) -> ContentFittingFunction {
        return ContentFittingFunction { availableHeight in
            let firstRect = first.function(availableHeight)
            let secondRect = second.function(availableHeight)
            
            if let firstRect = firstRect {
                if let secondRect = secondRect {
                    return ContentFittingRect(
                        rectRelativeToWindow: firstRect.rect.union(secondRect.rect)
                    )
                } else {
                    return firstRect
                }
            } else {
                return secondRect
            }
        }
    }
    
    public static func union(_ functions: [ContentFittingFunction]) -> ContentFittingFunction? {
        if let first = functions.first {
            let other = functions.dropFirst()
            
            return other.reduce(first, { (combined, function) -> ContentFittingFunction in
                return union(combined, function)
            })
        } else {
            return nil
        }
    }
    
    // E.g.:
    //
    // 1. Having 2 views: morePriorView, lessPriorView, notPriorAtAllView.
    // 2. Calling this:
    //
    // ContentFittingFunctionBuilder.tryFitAllWithDescendingPriority(
    //     ContentFittingFunctionBuilder.boundsOfView(morePriorView),
    //     ContentFittingFunctionBuilder.boundsOfView(lessPriorView),
    //     ContentFittingFunctionBuilder.boundsOfView(notPriorAtAllView),
    // )
    //
    // First, try to fit all views.
    // If they don't fit, try to fit without notPriorAtAllView: morePriorView + lessPriorView.
    // If they don't fit, try to fit without lessPriorView: morePriorView.
    public static func tryFitAllWithDescendingPriority(_ functions: [ContentFittingFunction]) -> ContentFittingFunction {
        return ContentFittingFunction { availableHeight in
            var functions = functions
            
            while functions.count > 0 {
                if let unionFunction = union(functions) {
                    let rect = unionFunction.function(availableHeight)
                    if let rect = rect , rect.fits(height: availableHeight) {
                        return rect
                    }
                } else {
                    break
                }
                
                functions.removeLast()
            }
            
            return nil
        }
    }
    
    // Alias
    public static func tryFitAllWithDescendingPriority(_ functions: ContentFittingFunction...) -> ContentFittingFunction {
        let functions: [ContentFittingFunction] = functions
        return tryFitAllWithDescendingPriority(functions)
    }
}
