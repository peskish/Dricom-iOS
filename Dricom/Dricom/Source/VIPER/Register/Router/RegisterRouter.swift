import CTAssetsPickerController

protocol RegisterRouter: class, RouterFocusable, RouterDismissable, RouterCameraShowable, RouterFeedbackShowable {
    func showMediaPicker(delegate: CTAssetsPickerControllerDelegate)
}
