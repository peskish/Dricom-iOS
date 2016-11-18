import Photos

final class PHAssetUtilities {
    class func getImageFrom(asset: PHAsset, size: CGSize? = nil) -> UIImage {
        let size = size ?? PHImageManagerMaximumSize
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option) {
            result, info in
            thumbnail = result!
        }
        return thumbnail
    }
}
