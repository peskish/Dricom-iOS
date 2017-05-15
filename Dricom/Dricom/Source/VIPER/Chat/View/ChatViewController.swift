import UIKit
import JSQMessagesViewController

final class ChatViewController: JSQMessagesViewController,
    ChatViewInput,
    DisposeBag,
    DisposeBagHolder,
    ViewControllerPositionHolder
{
    // MARK: - State
    var messages = [JSQMessage]()
    
    // MARK: - Init
    @nonobjc init(position: ViewControllerPosition) {
        self.position = position
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: левая кнопка в зависимости от position
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
        view.endEditing(true)
        onViewWillDisappear?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        onViewDidDisappear?()
    }
    
    // MARK: - ChatViewInput
    func setChannelInfo(_ info: ChannelInfo) {
        self.title = info.collocutorName
        self.senderId = info.ownerId
        self.senderDisplayName = info.ownerName
    }
    
    @nonobjc func setMessages(_ messages: [JSQMessage]) {
        self.messages = messages
        self.finishReceivingMessage(animated: true)
    }
    
    // MARK: - JSQMessagesViewController
    public override func didPressAccessoryButton(_ sender: UIButton!) {
        print("Not implemented yet")
    }
    
    public override func didPressSend(
        _ button: UIButton!,
        withMessageText text: String!,
        senderId: String!,
        senderDisplayName: String!,
        date: Date!)
    {
        print("Send text: \(text)")
    }
    
    // MARK: - ViewLifecycleObservable
    var onViewDidLoad: (() -> ())?
    var onViewWillAppear: (() -> ())?
    var onViewDidAppear: (() -> ())?
    var onViewWillDisappear: (() -> ())?
    var onViewDidDisappear: (() -> ())?
    
    // MARK: - ViewControllerPositionHolder
    var position: ViewControllerPosition?
    
    // MARK: - DisposeBagHolder
    let disposeBag: DisposeBag = DisposeBagImpl()
}
