import Foundation

// Use when "nil" is not an error - for optional results.
public final class OptionalNetworkResponseConverter<T>: NetworkResponseConverter {
    public typealias ConversionResult = T?
    
    private let converter: NetworkResponseConverterOf<T>
    
    init(_ converter: NetworkResponseConverterOf<T>) {
        self.converter = converter
    }
    
    convenience init<C: NetworkResponseConverter>(_ converter: C) where C.ConversionResult == T {
        self.init(NetworkResponseConverterOf(converter))
    }
    
    //MARK: - NetworkResponseConverter
    
    public func decodeResponse(data: Data) -> ConversionResult? {
        return converter.decodeResponse(data: data)
    }
    
    public func decodeResponse(json: [String: Any]) -> ConversionResult? {
        return converter.decodeResponse(json: json)
    }
    
    public func decodeResponse(jsonArray: [[String: Any]]) -> ConversionResult? {
        return converter.decodeResponse(jsonArray: jsonArray)
    }
}
