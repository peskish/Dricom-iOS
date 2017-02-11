public final class ContentFittingCombineFunctionBuilder {
    public static func fitSubviewFirst() -> ContentFittingCombineFunction {
        return ContentFittingCombineFunction { (currentFunction, subviewFunction) -> ContentFittingFunction in
            return ContentFittingFunctionBuilder.tryFitAllWithDescendingPriority(
                subviewFunction,
                currentFunction
            )
        }
    }
}