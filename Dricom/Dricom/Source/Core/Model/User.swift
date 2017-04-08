import Unbox

struct User {
    let userId: String
    let avatar: String?
    let name: String?
    let licenses: [License]
    let phone: String?
    let email: String?
    
    struct License: Equatable, Unboxable {
        let id: String
        let title: String
        
        init(unboxer: Unboxer) throws {
            id = try unboxer.unbox(key: "id")
            title = try unboxer.unbox(key: "title")
        }
        
        static func ==(left: License, right: License) -> Bool {
            return left.id == right.id && left.title == right.title
        }
    }
}

extension User: Equatable {
    static func ==(left: User, right: User) -> Bool {
        return left.avatar == right.avatar
            && left.licenses == right.licenses
            && left.name == right.name
            && left.phone == right.phone
            && left.email == right.email
            && left.userId == right.userId
    }
}

extension User: Unboxable {
    init(unboxer: Unboxer) throws {
        avatar = unboxer.unbox(key: "avatar")
        name = unboxer.unbox(key: "first_name") // TODO: return `name` back
        licenses = try unboxer.unbox(key: "licenses")
        phone = unboxer.unbox(key: "phone")
        email = unboxer.unbox(key: "email")
        userId = try unboxer.unbox(key: "id")
    }
}
