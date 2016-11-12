import UIKit

final class FeedbackAssemblyImpl: BaseAssembly, FeedbackAssembly {
    // MARK: - FeedbackAssembly
    func module(
        configure: (_ module: FeedbackModule) -> ())
        -> UIViewController
    {
        let interactor = FeedbackInteractorImpl()
        
        let viewController = FeedbackViewController()
        
        let router = FeedbackRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController,
            mailComposeDelegateService: serviceFactory.mailComposeDelegateService()
        )
        
        let presenter = FeedbackPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
