protocol RouterFocusable: class {
    func focusOnCurrentModule()
}

extension RouterFocusable where Self: BaseRouter {
    func focusOnCurrentModule() {
        guard let viewController = viewController else { return }
        
        if viewController.presentedViewController != nil {
            viewController.dismiss(animated: true, completion: nil)
        }
        
        if navigationController?.presentedViewController != nil {
            navigationController?.dismiss(animated: true, completion: nil)
        }
        
        if navigationController?.topViewController !== viewController {
            let _ = navigationController?.popToViewController(viewController, animated: true)
        }
    }
}
