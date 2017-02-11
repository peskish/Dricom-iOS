class RecursionBreakingClosure {
    var closure: (() -> ())? {
        didSet {
            closureIsCalled = false
        }
    }
    var closureIsCalled = false
    
    func invoke() {
        if let closure = closure , !closureIsCalled {
            closureIsCalled = true
            closure()
        }
        closureIsCalled = false
    }
}
