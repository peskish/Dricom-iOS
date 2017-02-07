import Unbox

public protocol NetworkResponseConverter {
    associatedtype ConversionResult
    
    func decodeResponse(data: Data) -> ConversionResult?
    func decodeResponse(json: [String: Any]) -> ConversionResult?
    func decodeResponse(jsonArray: [[String: Any]]) -> ConversionResult?
}

extension NetworkResponseConverter {
    func decodeResponse(data: Data) -> ConversionResult? {
        if let json = data.toJSON {
            return decodeResponse(json: json)
        } else if let jsonArray = data.toJsonArray {
            return decodeResponse(jsonArray: jsonArray)
        } else {
            return nil
        }
    }
    
    func decodeResponse(json: [String: Any]) -> ConversionResult? {
        return nil
    }
    
    func decodeResponse(jsonArray: [[String: Any]]) -> ConversionResult? {
        return nil
    }
}

final class UnboxingNetworkResponseConverter<T>: NetworkResponseConverter where T: Unboxable {
    typealias ConversionResult = T
    
    func decodeResponse(json: [String: Any]) -> ConversionResult? {
        do {
            let response: ConversionResult = try unbox(dictionary: json)
            return response
        } catch {
            debugPrint("Unable to Unbox Response Due to Error (\(error))")
            return nil
        }
    }
}

final class CollectionUnboxingNetworkResponseConverter<T>: NetworkResponseConverter where T: Collection, T.Iterator.Element: Unboxable {
    typealias ConversionResult = T
    
    func decodeResponse(jsonArray: [[String: Any]]) -> ConversionResult? {
        let responseElements: [ConversionResult.Generator.Element] = jsonArray.flatMap {
            do {
                let item: ConversionResult.Iterator.Element = try unbox(dictionary: $0)
                return item
            } catch {
                debugPrint("Unable to Unbox Response Due to Error (\(error))")
                return nil
            }
        }
        
        let response = responseElements as? ConversionResult // dunno how to avoid type casting
        return response
    }
}
