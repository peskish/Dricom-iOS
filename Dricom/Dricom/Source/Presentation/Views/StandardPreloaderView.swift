import UIKit

public enum StandardPreloaderViewStyle {
    case dark
    case light
}

protocol StandardPreloaderViewHolder {
    var preloader: StandardPreloaderView { get }
}

extension ActivityDisplayable where Self: StandardPreloaderViewHolder, Self: UIView {
    func startActivity() {
        preloader.setLoading(true)
    }
    
    func stopActivity() {
        preloader.setLoading(false)
    }
}

public final class StandardPreloaderView: UIView {
    // MARK: - Private
    private let preloaderView: UIActivityIndicatorView
    
    // MARK: - Init
    init(style: StandardPreloaderViewStyle)
    {
        let backgroundColor: UIColor
        let activityIndicatorStyle: UIActivityIndicatorViewStyle
        
        switch style {
        case .dark:
            backgroundColor = UIColor(white: 1, alpha: 0.3)
            activityIndicatorStyle =  .gray
        case .light:
            backgroundColor = .clear
            activityIndicatorStyle = .whiteLarge
        }
        
        self.preloaderView = UIActivityIndicatorView(
            activityIndicatorStyle: activityIndicatorStyle
        )
        
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        
        alpha = 0
        addSubview(preloaderView)
    }
    
    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        preloaderView.sizeToFit()
        
        if let window = window {
            preloaderView.center = convert(window.center, from: nil)
        }
        else {
            preloaderView.center = bounds.center
        }
    }
    
    // MARK: - Public
    public func setLoading(_ loading: Bool) {
        if loading {
            preloaderView.startAnimating()
        } else {
            preloaderView.stopAnimating()
        }
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.alpha = loading ? 1 : 0
            }
        )
    }
    
    // MARK :- Unused
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
