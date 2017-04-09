import Alamofire

protocol NetworkClient: class {
    func send<T, R: NetworkRequest>(
        request: R,
        completion: @escaping ApiResult<T>.Completion) where R.Result == T
}

final class NetworkClientImpl: NetworkClient {
    // MARK: - Properties
    private let baseUrl = "http://dricom.hftgeek.com/"
    
    // MARK: - Dependencies
    private let authorizationStatusHolder: AuthorizationStatusHolder
    
    // MARK: - Init
    init(authorizationStatusHolder: AuthorizationStatusHolder) {
        self.authorizationStatusHolder = authorizationStatusHolder
    }
    
    // MARK: - NetworkClient
    func send<T, R: NetworkRequest>(
        request: R,
        completion: @escaping ApiResult<T>.Completion) where R.Result == T
    {
        guard let url = makeUrl(from: request) else {
            completion(.error(.badRequest))
            return
        }
        
        var headers = HTTPHeaders()
        
        if request.isAuthorizationRequired {
            switch authorizationStatusHolder.authorizationStatus {
            case .notAuthorized:
                completion(.error(.userIsNotAuthorized))
                return
            case .authorized(let jwt):
                headers["Authorization"] = "JWT " + jwt
            }
        }
        
        Alamofire.request(
            url,
            method: request.httpMethod,
            parameters: request.params,
            encoding: request.encoding,
            headers: headers
        ).responseData { response in
            if let httpStatusCode = response.response?.statusCode {
                switch(httpStatusCode) {
                case 400:
                    completion(.error(.badRequest))
                    return
                case 401:
                    completion(.error(.userIsNotAuthorized))
                    return
                case 500:
                    completion(.error(.internalServerError))
                    return
                default:
                    break
                }
            }
            
            switch response.result {
            case .success(let value):
                if let error = request.errorConverter.decodeResponse(data: value) {
                    completion(.error(.apiError(error)))
                } else if let result = request.resultConverter.decodeResponse(data: value) {
                    completion(.data(result))
                } else {
                    completion(.error(.parsingFailure))
                }
            case .failure(let error):
                completion(.error(.unknownError(error)))
            }
        }
    }
    
    // MARK: - Private
    
    // MARK: URL
    private func makeUrl<R: NetworkRequest>(from request: R) -> URL? {
        // Django requires the trailing `/`, it fails with 500 otherwise
        return URL(string: baseUrl + request.path + "/")
    }
}
