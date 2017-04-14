import UIKit

protocol MessageDisplayable: AlertDisplayable {
    func showError(_ networkRequestError: NetworkRequestError)
}

extension MessageDisplayable where Self: AlertDisplayable {
    func showError(_ networkRequestError: NetworkRequestError) {
        switch networkRequestError {
        case .badRequest, .internalServerError, .parsingFailure, .dataEncodingFailure:
            showUnknownErrorMessage()
        case .userIsNotAuthorized:
            break
        case .apiError(let apiError):
            showError(apiError)
        case .unknownError(let error):
            debugPrint(error.localizedDescription)
            showUnknownErrorMessage()
        }
    }
    
    func showError(_ apiError: ApiError) {
        if let message = apiError.message {
            showErrorMessage(message)
        } else {
            showUnknownErrorMessage()
        }
    }
    
    func showInfoMessage(_ message: String) {
        showAlert(StandardAlert(title: "", message: message))
    }
    
    func showErrorMessage(_ message: String) {
        showAlert(StandardAlert(title: "Ошибка", message: message))
    }
    
    private func showUnknownErrorMessage() {
        showErrorMessage("Неизвестная ошибка\nПожалуйста, попробуйте позднее.")
    }
}
