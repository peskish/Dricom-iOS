// Observing is internal for AvitoCollectionView framework.
// Only notification method is public. This is for simplicity.
// To allow only 1 observer which is KeyboardAvoidingService at the moment.
public final class KeyboardAvoidingSettingsObservable {
    var onChange: (() -> ())? {
        get { return onChangeRecursionBreakingClosure.closure }
        set { onChangeRecursionBreakingClosure.closure = newValue }
    }
    
    private let onChangeRecursionBreakingClosure = RecursionBreakingClosure()
    
    public init() {
    }
    
    public func notifyAboutChange() {
        onChangeRecursionBreakingClosure.invoke()
    }
}
