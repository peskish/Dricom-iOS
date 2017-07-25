import Paparazzo

protocol RouterPhotoPickerShowable: class {
    func showPhotoLibrary(maxSelectedItemsCount: Int, configuration: (PhotoLibraryModule) -> ())
}

extension RouterPhotoPickerShowable where Self: BaseRouter {
    func showPhotoLibrary(maxSelectedItemsCount: Int, configuration: (PhotoLibraryModule) -> ()) {
        let assembly = assemblyFactory.photoLibraryAssembly()
        let targetViewController = assembly.module(
            selectedItems: [],
            maxSelectedItemsCount: maxSelectedItemsCount,
            configuration: configuration
        )
        let navigationController = UINavigationController(rootViewController: targetViewController)
        navigationController.setStyle(.main)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
