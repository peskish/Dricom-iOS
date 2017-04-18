import Unbox

struct SearchUserResult: Unboxable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [User]
    
    init(unboxer: Unboxer) throws {
        count = try unboxer.unbox(key: "count")
        next = try? unboxer.unbox(key: "next")
        previous = try? unboxer.unbox(key: "previous")
        results = unboxer.unbox(key: "results", fallbackValue: [])
    }
}
