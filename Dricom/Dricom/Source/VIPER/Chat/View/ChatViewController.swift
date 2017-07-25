import UIKit
import JSQMessagesViewController
import AlamofireImage

final class ChatViewController: JSQMessagesViewController,
    ChatViewInput,
    DisposeBag,
    DisposeBagHolder,
    ViewControllerPositionHolder
{
    // MARK: - State
    var messages = [JSQMessage]()
    var avatars = [String: UIImage]()
    
    // MARK: - Properties
    private let incomingBubble: JSQMessagesBubbleImage
    private let outgoingBubble: JSQMessagesBubbleImage
    private static let avatarDiameter: UInt = 40
    
    // MARK: - Init
    @nonobjc init(position: ViewControllerPosition, user: User, collocutor: User) {
        self.position = position
        
        incomingBubble = JSQMessagesBubbleImageFactory(bubble: .jsq_bubbleCompactTailless(), capInsets: .zero)
            .incomingMessagesBubbleImage(with: .drcPaleGreyFour)
        outgoingBubble = JSQMessagesBubbleImageFactory(bubble: .jsq_bubbleCompactTailless(), capInsets: .zero)
            .outgoingMessagesBubbleImage(with: .drcBlue)
        
        super.init(nibName: nil, bundle: nil)
        
        automaticallyScrollsToMostRecentMessage = true
        
        // Set avatar sizes
        let avatarImageSide = CGFloat(ChatViewController.avatarDiameter)
        let avatarSize = CGSize(width: avatarImageSide, height: avatarImageSide)
        collectionView?.collectionViewLayout.incomingAvatarViewSize = avatarSize
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = avatarSize
        
        // Load user's and collocutor's avatars
        loadAvatar(for: user)
        loadAvatar(for: collocutor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadAvatar(for user: User) {
        guard let avatarImage = user.avatar?.image, let imageUrl = URL(string: avatarImage) else { return }
        
        let urlRequest = URLRequest(url: imageUrl)
        let avatarImageSide = CGFloat(ChatViewController.avatarDiameter)
        let avatarSize = CGSize(width: avatarImageSide, height: avatarImageSide)
        let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: avatarSize,
            radius: avatarImageSide/2
        )
        
        ImageDownloader.default.download(urlRequest, filter: imageFilter)  { response in
            if case .success(let image) = response.result {
                self.avatars[user.id] = image
            }
        }
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up font in bubbles
        collectionView.collectionViewLayout.messageBubbleFont = SpecFonts.ralewayRegular(14)
        
        // Hide left button - media upload is currently not supported
        inputToolbar.contentView?.leftBarButtonItem = nil
        
        if let position = position, position == .modal {
            navigationItem.backBarButtonItem = nil
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: #imageLiteral(resourceName: "Close blue"),
                style: .plain,
                target: self,
                action: #selector(onCloseTap(_:))
            )
        } else {
            navigationItem.backBarButtonItem = UIBarButtonItem(
                title: "",
                style: .plain,
                target: nil,
                action: nil
            )
        }
        
        onViewDidLoad?()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setStyle(.main)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.setNavigationBarHidden(false, animated: true)
        
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
    
    var onTapSendButton: ((_ text: String) -> ())?
    
    var onCloseTap: (() -> ())?
    @objc private func onCloseTap(_ sender: UIControl) {
        onCloseTap?()
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
        onTapSendButton?(text)
        self.finishSendingMessage(animated: true)
    }
    
    // MARK: Collection view data source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(
        _ collectionView: JSQMessagesCollectionView,
        messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(
        _ collectionView: JSQMessagesCollectionView,
        messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    }

    override func collectionView(
        _ collectionView: JSQMessagesCollectionView,
        avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource?
    {
        if let message = messages.elementAtIndex(indexPath.item),
            let avatarImage = avatars[message.senderId] {
            return JSQMessagesAvatarImageFactory.avatarImage(
                with: avatarImage,
                diameter: ChatViewController.avatarDiameter
            )
        } else {
            return nil
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let message = messages.elementAtIndex(indexPath.item) {
            if message.senderId == self.senderId {
                cell.textView.textColor = .drcWhite
            } else {
                cell.textView.textColor = .drcSlate
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        // Show a timestamp for every 3rd message
        if (indexPath.item % 3 == 0), let message = self.messages.elementAtIndex(indexPath.item) {
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        } else {
            return nil
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        // Don't show collocutor's name above the message bubble
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        // Show a timestamp for every 3rd message
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.senderId {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
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
