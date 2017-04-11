import Unbox

public struct SuccessResponse: Unboxable {
    public let value: Bool
    
    // MARK: - Unboxable
    public init(unboxer: Unboxer) throws {
        value = try unboxer.unbox(key: "success")
    }
}
