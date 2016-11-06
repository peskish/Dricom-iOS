protocol RouterDismissable: class {
    func dismissCurrentModule()
}

extension RouterDismissable where Self: BaseRouter {
    func dismissCurrentModule() {
        if let presentingViewController = viewController?.presentingViewController {
            presentingViewController.dismiss(animated: true, completion: nil)
        } else if let navigationController = navigationController, let viewController = viewController,
            let viewControllerIndex = navigationController.viewControllers.index(of: viewController),
            viewControllerIndex != 0
        {
            navigationController.popToViewController(
                navigationController.viewControllers[viewControllerIndex],
                animated: true
            )
        }
    }
}
