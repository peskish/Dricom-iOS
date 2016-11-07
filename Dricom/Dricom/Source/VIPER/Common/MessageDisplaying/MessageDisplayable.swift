import UIKit

protocol MessageDisplayable: AlertDisplayable {
    func showError(networkError: NetworkError)
}

extension MessageDisplayable where Self: AlertDisplayable {
    func showError(networkError: NetworkError) {
        showAlert(StandardAlert(title: "Ошибка", message: networkError.message))
    }
    
    func showInfoMessage(message: String) {
        showAlert(StandardAlert(title: "", message: message))
    }
}
