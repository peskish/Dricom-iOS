import Foundation

final class FeedbackPresenter:
    FeedbackModule
{
    // MARK: - Private properties
    private let interactor: FeedbackInteractor
    private let router: FeedbackRouter
    
    // MARK: - Init
    init(interactor: FeedbackInteractor,
         router: FeedbackRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: FeedbackViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.setSupportButtonTitle("Сообщить о проблеме")
        view?.setFeedbackButtonTitle("Обратная связь")
        
        view?.onCloseButtonTap = { [weak self] in
            self?.onFinish?(.finished)
        }
        
        view?.onFbButtonTap = { [weak self] in
            self?.interactor.openFb()
        }
        
        view?.onVkButtonTap = { [weak self] in
            self?.interactor.openVk()
        }
        
        view?.onInstagramButtonTap = { [weak self] in
            self?.interactor.openInstagram()
        }
        
        view?.onFeedbackButtonTap = { [weak self] in
            self?.sendFeedbackEmail()
        }
        
        view?.onSupportButtonTap = { [weak self] in
            self?.sendSupportEmail()
        }
    }
    
    private func sendFeedbackEmail() {
        if interactor.canSendEmail() {
            router.showMailComposer(
                toRecepients: [interactor.adminEmail()],
                subject: "Отзыв о приложении",
                body: "Добрый день.\n",
                isHTML: false
            )
        } else {
            let alert = StandardAlert(message: "Вы можете связаться с нами по адресу admin@dricom.ru")
            view?.showAlert(alert)
        }
    }
    
    private func sendSupportEmail() {
        if interactor.canSendEmail() {
            let supportMessageData = interactor.supportMessageData()
            let subject = ["Обращение пользователя", supportMessageData.userEmail].flatMap{$0}.joined(separator: " ")
            
            router.showMailComposer(
                toRecepients: [interactor.adminEmail()],
                subject: subject,
                body: mailBodyFrom(supportMessageData: supportMessageData),
                isHTML: false
            )
        } else {
            let alert = StandardAlert(message: "Отправьте email по адресу \(interactor.adminEmail()), указав в тексте обращения Ваш email, модель Вашего устройства и установленную версию iOS.")
            view?.showAlert(alert)
        }
    }
    
    private func mailBodyFrom(supportMessageData: SupportMessageData) -> String {
        let separator = "________"
        let model = "Модель устройства: \(supportMessageData.deviceVersion)"
        let osVersion = "Версия ОС: \(supportMessageData.iosVersion)"
        let user = supportMessageData.userEmail.flatMap{ "Пользователь: \($0)" }
        let appVersion = "Версия приложения: \(supportMessageData.appVersion)"
        let allRows: [String?] = [separator, model, osVersion, user, appVersion, separator]
        return allRows.flatMap{$0}.joined(separator: "\n")
    }
    
    // MARK: - FeedbackModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((FeedbackResult) -> ())?
}

//- (NSString *)emailMessageBody {
//    NSMutableArray *environmentDescriptionFields = [NSMutableArray new];
//    if (deviceModel) {
//        [environmentDescriptionFields addObject:[NSString stringWithFormat:@"Модель устройства: %@", deviceModel]];
//    }
//    if (iosVersion) {
//        [environmentDescriptionFields addObject:[NSString stringWithFormat:@"Версия ОС: %@", iosVersion]];
//    }
//    if (self.email) {
//        [environmentDescriptionFields addObject:[NSString stringWithFormat:@"Пользователь: %@", self.email]];
//    }
//    if (applicationVersion) {
//        [environmentDescriptionFields addObject:[NSString stringWithFormat:@"Версия приложения: %@", applicationVersion]];
//    }
//    
//    NSString *messageBody = nil;
//    if (environmentDescriptionFields.count > 0) {
//        NSString *separator = @"________";
//        messageBody = [NSString stringWithFormat:@"\n%@\n%@\n%@", separator, [environmentDescriptionFields componentsJoinedByString:@"\n"], separator];
//    }
//    
//    return messageBody;
//}
