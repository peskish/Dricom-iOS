import UIKit
import Foundation

public enum SearchBarIcons {
    case clear
    case magnifyingGlass
}

public final class SearchBarView: UIView, UISearchBarDelegate {
    // MARK: - Subviews
    private let separatorView = UIView()
    private let searchBar = UISearchBar()
    
    // MARK: - Private properties
    private let textColor: UIColor
    private let placeholderColor: UIColor
    private let font: UIFont
    
    // MARK: - Init
    init(textColor: UIColor,
         placeholderColor: UIColor,
         separatorColor: UIColor,
         searchFieldBackgroundColor: UIColor,
         searchBarBackgroundColor: UIColor,
         font: UIFont,
         searchTextPositionAdjustment: UIOffset)
    {
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.font = font
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        addSubview(searchBar)
        addSubview(separatorView)
        
        searchBar.delegate = self
        searchBar.searchTextPositionAdjustment = searchTextPositionAdjustment
        
        setSearchFieldBackgroundColor(searchFieldBackgroundColor)
        setSearchBarBackgroundColor(searchBarBackgroundColor)
        
        separatorView.backgroundColor = separatorColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public callbacks
    public var onSearchButtonTap: (() -> ())?
    public var onTextChange: ((String) -> ())?
    public var onCancelButtonTap: (() -> ())?
    public var onShouldBeginEditing: (() -> (Bool))?
    public var onShouldEndEditing: (() -> (Bool))?
    public var onTextDidBeginEditing: (() -> ())?
    public var onTextDidEndEditing: (() -> ())?
    public var onShouldChangeText: ((NSRange, String) -> Bool)?
    public var onBookmarkTap: (() -> ())?
    public var onResultsListTap: (() -> ())?
    public var onActionButtonTap: (() -> ())?
    
    // MARK: - Public
    public var placeholder: String? {
        didSet {
            updateSearchBarAppearance()
        }
    }
    
    public var text: String? {
        get { return searchBar.text }
        set { searchBar.text = newValue }
    }
    
    public var separatorHidden: Bool {
        get { return separatorView.isHidden }
        set { separatorView.isHidden = newValue }
    }
    
    public func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        searchBar.setShowsCancelButton(showsCancelButton, animated: animated)
    }
    
    public func setSearchBarBackgroundColor(_ searchBarBackgroundColor: UIColor) {
        let patternSize = CGSize(width: 1, height: 1)
        
        let imagePattern = UIImage.imageWithColor(searchBarBackgroundColor, imageSize: patternSize)
        
        if let imagePattern = imagePattern {
            searchBar.setBackgroundImage(imagePattern, for: .any, barMetrics: .default)
        }
    }

    // MARK: - UIView
    public override var accessibilityIdentifier: String? {
        didSet {
            searchBar.accessibilityIdentifier = accessibilityIdentifier
        }
    }
    
    public override var accessibilityValue: String? {
        didSet {
            searchBar.accessibilityValue = accessibilityValue
        }
    }
    
    public override var tintColor: UIColor? {
        didSet {
            searchBar.tintColor = tintColor
        }
    }
    
    // MARK: - Internal
    func setImage(_ image: UIImage, forIcon icon: SearchBarIcons, state: UIControlState) {
        switch icon {
        case .clear:
            searchBar.setImage(image, for: .clear, state: state)
        case .magnifyingGlass:
            searchBar.setImage(image, for: .search, state: state)
        }
    }
    
    // MARK: - Private
    private func setSearchFieldBackgroundColor(_ searchFieldBackgroundColor: UIColor) {
        let patternSize = CGSize(width: 32, height: 32)
        
        let imagePattern = UIImage.imageWithColor(searchFieldBackgroundColor, imageSize: patternSize)
        let roundedImagePattern = imagePattern.flatMap { UIImage.roundedImage($0, cornerRadius: patternSize.height/2) }
        
        if let roundedImagePattern = roundedImagePattern {
            searchBar.setSearchFieldBackgroundImage(roundedImagePattern, for: .normal)
        }
    }
    
    private func updateSearchBarAppearance() {
        searchBar.applyAppearance(
            textColor: textColor,
            placeholderColor: placeholderColor,
            font: font,
            placeholderText: placeholder ?? ""
        )
        
        setCancelButtonLookAlwaysEnabled()
    }
    
    // MARK: - Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Updating search bar appearance does not work if called directly from `init`,
        // because the text field and other views are added lazily
        updateSearchBarAppearance()
        
        searchBar.frame = bounds
        
        // Force search bar to relayout. Out layout depends on search bar's text field's position
        searchBar.layoutIfNeeded()
        
        let separatorHeight = 1.0 / UIScreen.main.scale
        separatorView.frame = CGRect(
            x: 0,
            y: searchBar.bottom - separatorHeight,
            width: width,
            height: separatorHeight
        )
    }
    
    // MARK: - UISearchBarDelegate
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        onSearchButtonTap?()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onTextChange?(searchText)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onCancelButtonTap?()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        onTextDidBeginEditing?()
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        onTextDidEndEditing?()
        enableAllSearchBarButtons() // Kludge to make `Cancel` button always enabled
    }
    
    public func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        onBookmarkTap?()
    }
    
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        onResultsListTap?()
    }
    
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return onShouldChangeText?(range, text) ?? true
    }
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return onShouldBeginEditing?() ?? true
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return onShouldEndEditing?() ?? true
    }
    
    // MARK: - Private
    private func enableAllSearchBarButtons() {
        OperationQueue.main.addOperation { [weak self] in
            if let strongSelf = self {
                for button in strongSelf.searchBar.buttonsInSubviews() {
                    button.isEnabled = true
                }
            }
        }
    }
    
    private func setCancelButtonLookAlwaysEnabled() {
        for button in self.searchBar.buttonsInSubviews() {
            let enabledColor = button.titleColor(for: .normal)
            let disabledColor = button.titleColor(for: .disabled)
            
            if enabledColor != disabledColor { // Kludje to find `cancel` button
                button.setTitleColor(enabledColor, for: .disabled)
            }
        }
    }
}

private extension UIView {
    func applyAppearance(textColor: UIColor, placeholderColor: UIColor, font: UIFont, placeholderText: String)
    {
        subviews.forEach { subview in
            switch subview {
            case let textField as UITextField:
                let attributedPlaceholderText = NSAttributedString(
                    string: placeholderText,
                    attributes: [NSForegroundColorAttributeName: placeholderColor]
                )
                
                textField.attributedPlaceholder = attributedPlaceholderText
                textField.textColor = textColor
                textField.font = font
                
                textField.defaultTextAttributes = [
                    NSFontAttributeName: font,
                    NSForegroundColorAttributeName: textColor
                ]
                
                textField.clearButtonMode = .whileEditing
                textField.enablesReturnKeyAutomatically = false // Makes `return` key always enabled
                
            default:
                subview.applyAppearance(
                    textColor: textColor,
                    placeholderColor: placeholderColor,
                    font: font,
                    placeholderText: placeholderText
                )
            }
        }
    }
    
    func textFieldInSubviews() -> UITextField? {
        for subview in subviews {
            switch subview {
            case let textField as UITextField:
                return textField
            default:
                if let textField = subview.textFieldInSubviews() {
                    return textField
                }
            }
        }
        return nil
    }
    
    func buttonsInSubviews() -> [UIButton] {
        var result = [UIButton]()
        
        for subview in subviews {
            switch subview {
            case let button as UIButton:
                result.append(button)
            default:
                result.append(contentsOf: subview.buttonsInSubviews())
            }
        }
        
        return result
    }
}
