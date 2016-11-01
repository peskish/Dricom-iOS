import UIKit

public extension UIImage {
    static func imageWithColor(_ color: UIColor, imageSize: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContext(imageSize)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        currentContext.setFillColor(color.cgColor)
        currentContext.fill(CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return result
    }
    
    func imageByScalingAndCropping(_ targetSize: CGSize) -> UIImage? {
        let sourceImage = self
        let newImage: UIImage?
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        
        if imageSize != targetSize {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            //center the image
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else {
                if (widthFactor < heightFactor) {
                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
                }
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        
        var thumbnailRect = CGRect()
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.draw(in: thumbnailRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        if newImage == nil {
            debugPrint("Could not scale image")
        }
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func roundedImage(_ image: UIImage, cornerRadius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: CGPoint.zero, size: image.size)
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func opaqueImage() -> UIImage? {
        let imageSize = size
        UIGraphicsBeginImageContextWithOptions(imageSize, true, UIScreen.main.scale)
        draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let optimizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return optimizedImage
    }
}
