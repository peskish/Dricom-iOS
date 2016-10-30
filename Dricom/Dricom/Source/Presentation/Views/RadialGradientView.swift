import UIKit

/// View with programmatically created radial gradient
final class RadialGradientView: UIView {
    // MARK: Properties
    var edgeBackgroundColor: CGColor
    var centerBackgroundColor: CGColor
    
    // MARK: Init
    init(
        edgeBackgroundColor: CGColor = SpecColors.Background.defaultEdge.cgColor,
        centerBackgroundColor: CGColor = SpecColors.Background.defaultCenter.cgColor
        )
    {
        self.edgeBackgroundColor = edgeBackgroundColor
        self.centerBackgroundColor = centerBackgroundColor
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Drawing
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [centerBackgroundColor, edgeBackgroundColor, edgeBackgroundColor] as CFArray
        
        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors,
            locations: nil
            ) else { return }
        
        context?.drawRadialGradient(
            gradient,
            startCenter: frame.center,
            startRadius: 0,
            endCenter: frame.center,
            endRadius: 500,
            options: CGGradientDrawingOptions(rawValue: UInt32(0))
        )
    }
}
