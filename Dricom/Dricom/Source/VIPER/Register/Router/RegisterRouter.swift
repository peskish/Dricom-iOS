import CTAssetsPickerController

protocol RegisterRouter: class, RouterFocusable, RouterDismissable, RouterCameraShowable {
    func showMediaPicker(delegate: CTAssetsPickerControllerDelegate)
}
