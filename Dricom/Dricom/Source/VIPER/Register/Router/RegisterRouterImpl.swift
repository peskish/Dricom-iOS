import CTAssetsPickerController

final class RegisterRouterImpl: BaseRouter, RegisterRouter {
    // MARK: - RegisterRouter
    func showMediaPicker(delegate: CTAssetsPickerControllerDelegate) {
        PHPhotoLibrary.requestAuthorization { authorizationStatus in
            DispatchQueue.main.async {
                let picker = CTAssetsPickerController()
                picker.showsEmptyAlbums = false
                picker.delegate = delegate
                self.viewController?.present(picker, animated: true, completion: nil)
            }
        }
    }
}
