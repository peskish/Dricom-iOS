import UIKit

extension UIFont {
  class func logoLargeFont() -> UIFont? { 
    return UIFont(name: "Lato-Semibold", size: 68.0)
  }

  class func logoMediumFont() -> UIFont? { 
    return UIFont(name: "Lato-Semibold", size: 48.0)
  }

  class func buttonInactiveFont() -> UIFont? { 
    return UIFont(name: "Lato-Medium", size: 34.0)
  }

  class func screenNameFont() -> UIFont? { 
    return UIFont(name: "Rubik-Medium", size: 34.0)
  }

  class func buttonActiveFont() -> UIFont? { 
    return UIFont(name: "Rubik-Regular", size: 34.0)
  }

  class func buttonActiveLightFont() -> UIFont? { 
    return UIFont(name: "Rubik-Regular", size: 34.0)
  }

  class func inputPlaceholderFont() -> UIFont? { 
    return UIFont(name: "Rubik-Regular", size: 32.0)
  }

  class func addPhotoFont() -> UIFont? { 
    return UIFont(name: "Rubik-Regular", size: 30.0)
  }

  class func feedbackLinkFont() -> UIFont? { 
    return UIFont(name: "Rubik-Regular", size: 28.0)
  }
}
