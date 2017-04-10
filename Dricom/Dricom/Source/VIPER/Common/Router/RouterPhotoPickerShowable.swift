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
        setupStyle(navigationController: navigationController)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    // TODO: Move to extension
    private func setupStyle(navigationController: UINavigationController?) {
        // Navigation bar
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.drcBlue
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.drcSlate,
            NSFontAttributeName: UIFont.drcScreenNameFont() ?? UIFont.systemFont(ofSize: 17)
        ]
        
        if let backgroundImage = UIImage.imageWithColor(UIColor.drcWhite) {
            navigationController?.navigationBar.setBackgroundImage(
                backgroundImage,
                for: .default
            )
        }
    }
}
