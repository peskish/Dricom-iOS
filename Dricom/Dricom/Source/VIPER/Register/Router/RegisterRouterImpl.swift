import Paparazzo

final class RegisterRouterImpl: BaseRouter, RegisterRouter {
    // MARK: - RegisterRouter
    func showPhotoLibrary(maxSelectedItemsCount: Int, configuration: (PhotoLibraryModule) -> ()) {
        let assembly = assemblyFactory.photoLibraryAssembly()
        let targetViewController = assembly.module(
            selectedItems: [],
            maxSelectedItemsCount: maxSelectedItemsCount,
            configuration: configuration
        )
        let navigationController = UINavigationController(rootViewController: targetViewController)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
