import Alamofire

protocol NetworkClient: class {
    func send<T, R: NetworkRequest>(
        request: R,
        completion: @escaping ApiResult<T>.Completion) where R.Result == T
    
    func send<T, R: MultipartFormDataRequest>(
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
        
        // Workaround for deal with missing `Authorization` header in redirected requests
        // https://github.com/Alamofire/Alamofire/issues/798
        Alamofire.SessionManager.default.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            var redirectedRequest = request
            
            if let originalRequest = task.originalRequest,
                let headers = originalRequest.allHTTPHeaderFields,
                let authorizationHeaderValue = headers["Authorization"] {
                redirectedRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
            }
            
            return redirectedRequest
        }
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
        
        if request.isAuthorizationRequired && !authorizationStatusHolder.isAuthorized {
            completion(.error(.userIsNotAuthorized))
            return
        }
        
        let dataRequest = Alamofire.request(
            url,
            method: request.httpMethod,
            parameters: request.params,
            encoding: request.encoding,
            headers: makeHeaders(from: request)
        )
        
        processDataRequest(dataRequest, request: request, completion: completion)
    }
    
    func send<T, R: MultipartFormDataRequest>(
        request: R,
        completion: @escaping ApiResult<T>.Completion) where R.Result == T
    {
        guard let url = makeUrl(from: request) else {
            completion(.error(.badRequest))
            return
        }
        
        guard let data = request.uploadData else {
            completion(.error(.badRequest))
            return
        }
        
        if request.isAuthorizationRequired && !authorizationStatusHolder.isAuthorized {
            completion(.error(.userIsNotAuthorized))
            return
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(
                    data,
                    withName: request.name,
                    fileName: request.fileName,
                    mimeType: request.mimeType
                )
            },
            to: url,
            method: request.httpMethod,
            headers: makeHeaders(from: request),
            encodingCompletion: { [weak self] encodingResult in
                
                switch encodingResult {
                case .success(let uploadRequest, _, _):
                    self?.processDataRequest(uploadRequest, request: request, completion: completion)
                case .failure:
                    completion(.error(.dataEncodingFailure))
                }
            }
        )
    }
    
    // MARK: - Private
    private func makeHeaders<R: NetworkRequest>(from request: R) -> HTTPHeaders {
        var headers = HTTPHeaders()
        
        if request.isAuthorizationRequired {
            switch authorizationStatusHolder.authorizationStatus {
            case .notAuthorized:
                break
            case .authorized(let jwt):
                headers["Authorization"] = "JWT " + jwt
            }
        }
        
        return headers
    }
    
    private func processDataRequest<T, R: NetworkRequest>(
        _ dataRequest: DataRequest,
        request: R,
        completion: @escaping ApiResult<T>.Completion) where R.Result == T
    {
        dataRequest.responseData { response in
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
    
    // MARK: URL
    private func makeUrl<R: NetworkRequest>(from request: R) -> URL? {
        var urlString = baseUrl + request.path
        if request.httpMethod == .post {
            // Django requires the trailing `/` for POST requests, it fails with 500 otherwise
            urlString += "/"
        }
        
        return URL(string: urlString)
    }
}
