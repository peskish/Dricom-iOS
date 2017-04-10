import Paparazzo

protocol RegisterRouter: class, RouterFocusable, RouterDismissable, RouterCameraShowable, RouterFeedbackShowable {
    func showPhotoLibrary(maxSelectedItemsCount: Int, configuration: (PhotoLibraryModule) -> ())
}
