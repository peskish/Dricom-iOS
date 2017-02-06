import Unbox

struct User: Equatable {
    // let userId: String // TODO: добавить с Ромой ID
    let avatar: String?
    let name: String?
    let licence: String?
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
        self.licence = licence
        self.phone = phone
        self.email = email
    }
    
    // MARK: Equatable
    static func ==(left: User, right: User) -> Bool {
        return left.avatar == right.avatar
            && left.licence == right.licence
            && left.name == right.name
            && left.phone == right.phone
            && left.email == right.email
            // && left.userId == right.userId
    }
    
    // MARK: Unboxable
//    init(unboxer: Unboxer) {
//        
//    }
}
