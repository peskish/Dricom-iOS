import Foundation

public extension Data {
    var toJSON: [String: AnyObject]? {
        if let json = toJsonObject as? [String: AnyObject] {
            return json
        }
        
        return nil
    }
    
    var toJsonArray: [[String: AnyObject]]? {
        if let jsonArray = toJsonObject as? [[String: AnyObject]] {
            return jsonArray
        }
        
        return nil
    }
    
    private var toJsonObject: Any? {
        guard count > 0 else { return nil }
        
        do  {
            return (try JSONSerialization.jsonObject(with: self, options:[.allowFragments]))
        }
        catch {
            return nil
        }
    }
}
