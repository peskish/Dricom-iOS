import UIKit

class BaseViewController: UIViewController,
    ViewLifecycleObservable,
    DisposeBag,
    DisposeBagHolder,
    ViewControllerPositionHolder {
    
    // MARK: - ViewControllerPositionHolder
    
    var position: ViewControllerPosition?
    
    // MARK: - ViewLifecycleObservable
    
    var onViewDidLoad: (() -> ())? {
        didSet {
            if isViewLoaded {
                assertionFailure("onViewDidLoad was set after view is loaded. This may cause callbacks to presenter of module, which is not completely configured and so the behavior is undefined yet. Please, inspect loadView() method of view controller and figure out why it is called for unconfigured module.")
                onViewDidLoad?()
            }
        }
    }
    var onViewWillAppear: (() -> ())?
    var onViewDidAppear: (() -> ())?
    var onViewWillDisappear: (() -> ())?
    var onViewDidDisappear: (() -> ())?
    
    // MARK: - DisposeBagHolder
    
    let disposeBag: DisposeBag = DisposeBagImpl()
    
    // MARK: - Lifecycle
    
    @nonobjc convenience init() {
        self.init(position: .pushed)
    }
    
    @nonobjc init(position: ViewControllerPosition) {
        self.position = position
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "use init")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        
        onViewDidLoad?()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        onViewWillAppear?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        onViewDidAppear?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        onViewWillDisappear?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        onViewDidDisappear?()
    }   
}
