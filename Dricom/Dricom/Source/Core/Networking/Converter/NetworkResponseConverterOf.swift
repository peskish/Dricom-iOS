import Foundation

// Use it to store instance of NetworkResponseConverter.
public final class NetworkResponseConverterOf<T>: NetworkResponseConverter {
    public typealias ConversionResult = T
    
    private let decodeResponseDataFunction: (_ data: Data) -> ConversionResult?
    private let decodeResponseJsonFunction: (_ json: [String: Any]) -> ConversionResult?
    private let decodeResponseJsonArrayFunction: (_ jsonArray: [[String: Any]]) -> ConversionResult?
    
    public init<C: NetworkResponseConverter>(_ converter: C) where C.ConversionResult == T {
        decodeResponseDataFunction = { data in
            return converter.decodeResponse(data: data)
        }
        decodeResponseJsonFunction = { json in
            return converter.decodeResponse(json: json)
        }
        decodeResponseJsonArrayFunction = { jsonArray in
            return converter.decodeResponse(jsonArray: jsonArray)
        }
    }
    
    public func decodeResponse(data: Data) -> ConversionResult? {
        return decodeResponseDataFunction(data)
    }
    
    public func decodeResponse(json: [String: Any]) -> ConversionResult? {
        return decodeResponseJsonFunction(json)
    }
    
    public func decodeResponse(jsonArray: [[String: Any]]) -> ConversionResult? {
        return decodeResponseJsonArrayFunction(jsonArray)
    }
}
