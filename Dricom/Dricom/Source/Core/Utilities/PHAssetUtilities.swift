import Photos

final class PHAssetUtilities {
    class func getAssetThumbnail(asset: PHAsset, size: CGSize? = nil) -> UIImage {
        let size = size ?? CGSize(width: asset.pixelWidth, height: asset.pixelWidth)
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
