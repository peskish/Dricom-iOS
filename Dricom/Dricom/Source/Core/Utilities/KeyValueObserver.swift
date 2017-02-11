import Foundation

// Translated to Swift from my very old Obj-C code. Can be rewritten. However, it works.
public final class KeyValueObserver: NSObject {
    public struct Change {
        public let oldValue: Any?
        public let newValue: Any?
        
        // Use it for optimisation of handling of change.
        // We can not guarantee that value is changed or not.
        //
        // Returns true if
        // 1. Values are changed
        // 2. Can not determine that values are changed or not
        //
        func valueIsChangedOrItCanNotBeDetermined() -> Bool {
            guard let oldValue = self.oldValue else {
                assertionFailure("KeyValueObserver: Old value is nil")
                return true // can not determine equality
            }
            guard let newValue = self.newValue as? NSObject else {
                assertionFailure("KeyValueObserver: New value is not NSObject")
                return true // can not determine equality
            }
            
            if newValue.isEqual(oldValue) {
                return false // definately equal
            } else {
                return true // not equal or can not determine equality
            }
        }
    }
    
    public typealias Observer = (Change) -> ()
    private struct ObserverAndSettings {
        let observer: Observer
        let ignoreIfUnchanged: Bool
    }
    
    // Pointers
    private var deinitObservableAssociatedObjectKey: UInt8 = 0
    private var kvoContext: UInt8 = 0
    
    private weak var objectVar: NSObject?
    private var observersByKeyPath: [String: ObserverAndSettings] = [:]
    
    private var notificationsAreEnabled: Bool = true
    
    public weak var object: NSObject? {
        get {
            return objectVar
        }
        set {
            if (objectVar != newValue) {
                if let objectVar = objectVar {
                    stopBeingObserverForAllKeyPaths(objectVar)
                }
                
                setupObservingObjectDeinit(
                    oldObject: objectVar,
                    newObject: newValue
                )
                
                objectVar = newValue;
                
                if let objectVar = objectVar {
                    for (keyPath, _) in observersByKeyPath {
                        becomeObserver(objectVar, keyPath: keyPath)
                    }
                }
            }
        }
    }
    
    // I'm not sure whether true for ignoreIfUnchanged should be used as default.
    // I'm not sure whether or not it can cause bugs.
    // I'm not sure if false can be also helpful (e.g. for detecting all assignments). Maybe it can be helpful for debugging stuff.
    public func setObserver(_ observer: @escaping Observer, keyPath: String, ignoreIfUnchanged: Bool = true) {
        observersByKeyPath[keyPath] = ObserverAndSettings(
            observer: observer,
            ignoreIfUnchanged: ignoreIfUnchanged
        )
        
        if let objectVar = objectVar {
            becomeObserver(objectVar, keyPath: keyPath)
        }
    }
    
    public func removeObserver(_ keyPath: String) {
        observersByKeyPath.removeValue(forKey: keyPath);
        
        if let objectVar = objectVar {
            stopBeingObserver(objectVar, keyPath: keyPath)
        }
    }
    
    public func removeAllObservers() {
        if let objectVar = objectVar {
            for (keyPath, _) in observersByKeyPath {
                stopBeingObserver(objectVar, keyPath: keyPath)
            }
        }
        
        observersByKeyPath.removeAll(keepingCapacity: false)
    }
    
    public func withoutObservingDo(_ closure: () -> ()) {
        let notificationsAreEnabled = self.notificationsAreEnabled
        self.notificationsAreEnabled = false
        closure()
        self.notificationsAreEnabled = notificationsAreEnabled
    }
    
    deinit {
        removeAllObservers()
    }
    
    @objc public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, context == &kvoContext {
            if let observerAndSettings = observersByKeyPath[keyPath] , notificationsAreEnabled {
                withoutObservingDo {
                    if let kvoChange = change {
                        let change = Change(
                            oldValue: kvoChange[.oldKey],
                            newValue: kvoChange[.newKey]
                        )
                        
                        let shouldNotify = observerAndSettings.ignoreIfUnchanged
                            ? change.valueIsChangedOrItCanNotBeDetermined() // false == ignore
                            : true
                        
                        if shouldNotify {
                            observerAndSettings.observer(change)
                        }
                        
                    }
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func becomeObserver(_ object: AnyObject, keyPath: String) {
        let options = NSKeyValueObservingOptions([.new, .old])
        object.addObserver(self, forKeyPath: keyPath, options: options, context: &kvoContext)
    }
    
    private func stopBeingObserver(_ object: AnyObject, keyPath: String) {
        object.removeObserver(self, forKeyPath: keyPath, context: &kvoContext)
    }
    
    private func stopBeingObserverForAllKeyPaths(_ object: AnyObject) {
        for (keyPath, _) in observersByKeyPath {
            stopBeingObserver(object, keyPath: keyPath)
        }
    }
    
    private func setupObservingObjectDeinit(oldObject: NSObject?, newObject: NSObject?) {
        class DeinitObservable: NSObject {
            var onDeinit: (() -> ())?
            
            deinit {
                onDeinit?()
            }
        }
        
        if let oldObject = oldObject {
            // Remove deinit observable from oldObject
            
            // Get old DeinitObservable
            let deinitObservableAssociatedObject = objc_getAssociatedObject(
                oldObject,
                &deinitObservableAssociatedObjectKey
            )
            
            // Unsubscribe from it
            if let deinitObservable = deinitObservableAssociatedObject as? DeinitObservable {
                deinitObservable.onDeinit = nil
            }
            
            // Delete it (we've unsubscribed before, so onDeinit will not do anything)
            objc_setAssociatedObject(
                oldObject,
                &deinitObservableAssociatedObjectKey,
                nil,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
        
        if let newObject = newObject {
            let deinitObservableAssociatedObject = objc_getAssociatedObject(
                newObject,
                &deinitObservableAssociatedObjectKey
            )
            
            let deinitObservable: DeinitObservable
            
            if let deinitObservableAssociatedObject = deinitObservableAssociatedObject as? DeinitObservable {
                deinitObservable = deinitObservableAssociatedObject
            } else {
                deinitObservable = DeinitObservable()
                objc_setAssociatedObject(
                    newObject,
                    &deinitObservableAssociatedObjectKey,
                    deinitObservable,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
            
            deinitObservable.onDeinit = { [weak self] in
                if self?.object === newObject {
                    self?.stopBeingObserverForAllKeyPaths(newObject)
                }
            }
        }
    }
}
