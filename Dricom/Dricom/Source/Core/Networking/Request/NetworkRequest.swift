import Alamofire
import Unbox

//MARK: - NetworkRequest -

protocol NetworkRequest {
    associatedtype Result
    
    var httpMethod: HTTPMethod { get }
    var isAuthorizationRequired: Bool { get }
    var path: String { get }
    var params: [String: Any] { get }
    var encoding: ParameterEncoding { get }
    var uploadData: Data? { get }
    
    var errorConverter: NetworkResponseConverterOf<ApiError> { get }
    var resultConverter: NetworkResponseConverterOf<Result> { get }
}

//MARK: - Default declarations

extension NetworkRequest {
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    var uploadData: Data? {
        return nil
    }
    var errorConverter: NetworkResponseConverterOf<ApiError> {
        return NetworkResponseConverterOf(ApiErrorConverter())
    }
}

final class ApiErrorConverter: NetworkResponseConverter {
    typealias ConversionResult = ApiError
    
    func decodeResponse(data: Data) -> ConversionResult? {
        guard let json = data.toJSON?["error"] as? [String: Any] else {
            return nil
        }
        return try? unbox(dictionary: json)
    }
}

extension NetworkRequest where Result: Unboxable {
    var resultConverter: NetworkResponseConverterOf<Result> {
        return NetworkResponseConverterOf(UnboxingNetworkResponseConverter<Result>())
    }
}

extension NetworkRequest where Result: Collection, Result.Iterator.Element: Unboxable {
    var resultConverter: NetworkResponseConverterOf<Result> {
        return NetworkResponseConverterOf(CollectionUnboxingNetworkResponseConverter<Result>())
    }
}
