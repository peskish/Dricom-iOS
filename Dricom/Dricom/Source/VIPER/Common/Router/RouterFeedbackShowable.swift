protocol RouterFeedbackShowable: class {
    func showFeedback()
}

extension RouterFeedbackShowable where Self: BaseRouter, Self: RouterFocusable {
    func showFeedback() {
        let assembly = assemblyFactory.feedbackAssembly()
        let targetViewController = assembly.module { feedbackModule in
            let module = feedbackModule
            feedbackModule.onFinish = {[weak module] _ in
                module?.dismissModule()
            }
        }
        let navigationController = BaseNavigationController(rootViewController: targetViewController)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
