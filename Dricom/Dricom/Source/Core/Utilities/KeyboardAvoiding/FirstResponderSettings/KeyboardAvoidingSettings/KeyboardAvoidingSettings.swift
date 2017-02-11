public struct KeyboardAvoidingSettings {
    var contentFittingFunction: ContentFittingFunction
    var contentFittingCombineFunction: ContentFittingCombineFunction
    var rectForContent: ContentFittingRect? // if defined, it will be used to fit content in it
    var observable: KeyboardAvoidingSettingsObservable
    
    public init(
        contentFittingFunction: ContentFittingFunction,
        contentFittingCombineFunction: ContentFittingCombineFunction,
        rectForContent: ContentFittingRect?,
        observable: KeyboardAvoidingSettingsObservable)
    {
        self.contentFittingFunction = contentFittingFunction
        self.contentFittingCombineFunction = contentFittingCombineFunction
        self.rectForContent = rectForContent
        self.observable = observable
    }
}