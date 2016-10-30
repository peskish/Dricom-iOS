protocol RouterFocusable {
    func focusOnCurrentModule()
}

extension RouterFocusable where Self: BaseRouter {
    func focusOnCurrentModule() {
        guard let viewController = viewController else { return }
        
        let _ = navigationController?.popToViewController(viewController, animated: true)
    }
}
