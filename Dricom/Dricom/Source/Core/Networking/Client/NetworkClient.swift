import Alamofire

protocol NetworkClient: class {
    func send<T, R: NetworkRequest>(
        request: R,
        completion: @escaping ApiResult<T>.Completion) where R.Result == T
    
    // TODO: сделать отдельный сервис для хранения сессии
    var jwt: String? { get set }
}

final class NetworkClientImpl: NetworkClient {
    // TODO: Сохранить в кейчейн? Спросить у Ромы, сколько он валиден.
    // Возможно надо хранить логин/пароль, а токен обновлять?
    var jwt: String?
    
    private let baseUrl = "http://dricom.hftgeek.com/"
    
    // MARK: - NetworkClient
    func send<T, R: NetworkRequest>(
        request: R,
        completion: @escaping ApiResult<T>.Completion) where R.Result == T
    {
        guard let url = makeUrl(from: request) else {
            completion(.error(.badRequest))
            return
        }
        
        Alamofire.request(
            url,
            method: request.httpMethod,
            parameters: request.params,
            encoding: request.encoding,
            headers: nil
        ).validate().responseData { response in
            switch response.result {
            case .success(let value):
                if let result = request.resultConverter.decodeResponse(data: value) {
                    completion(.data(result))
                } else if let error = request.errorConverter.decodeResponse(data: value) {
                    completion(.error(.apiError(error)))
                } else {
                    assertionFailure("Parsing failure with data: \(value.toJSON)")
                    completion(.error(.parsingFailure))
                }
            case .failure(let error):
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 400:
                        completion(.error(.badRequest))
                    case 401:
                        completion(.error(.userIsNotAuthorized))
                    case 500:
                        completion(.error(.internalServerError))
                    default:
                        completion(.error(.unknownError(error)))
                    }
                } else {
                    completion(.error(.unknownError(error)))
                }
            }
        }
    }
    
    // MARK: - Private
    
    // MARK: URL
    private func makeUrl<R: NetworkRequest>(from request: R) -> URL? {
        let path = preparedRequestPath(request.path)
        return URL(string: baseUrl + String(request.version) + path)
    }
    
    private func preparedRequestPath(_ path: String) -> String {
        // remove leading and trailing `/` characters
        let components = path.components(separatedBy: "/")
        let nonEmptyComponents = components.filter { !$0.isEmpty }
        
        // return leading `/` character
        return "/" + nonEmptyComponents.joined(separator: "/")
    }
}
