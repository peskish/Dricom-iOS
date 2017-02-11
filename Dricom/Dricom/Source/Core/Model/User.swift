import Unbox

struct User: Equatable, Unboxable {
    // let userId: String // TODO: добавить с Ромой ID
    let avatar: String?
    let name: String?
    let license: String?
    let phone: String?
    let email: String?
    
    init(
        avatar: String?,
        name: String?,
        licence: String?,
        phone: String?,
        email: String?)
    {
        self.avatar = avatar
        self.name = name
        self.license = licence
        self.phone = phone
        self.email = email
    }
    
    // MARK: Equatable
    static func ==(left: User, right: User) -> Bool {
        return left.avatar == right.avatar
            && left.license == right.license
            && left.name == right.name
            && left.phone == right.phone
            && left.email == right.email
            // && left.userId == right.userId
    }
    
    // MARK: Unboxable
    init(unboxer: Unboxer) throws {
        avatar = unboxer.unbox(key: "avatar")
        name = unboxer.unbox(key: "name")
        license = unboxer.unbox(key: "license")
        phone = unboxer.unbox(key: "phone")
        email = unboxer.unbox(key: "email")
    }
}
