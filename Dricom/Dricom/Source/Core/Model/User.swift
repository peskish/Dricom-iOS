import Unbox

struct User: Equatable, Unboxable {
    // MARK: - Inner data structures
    struct Avatar: Equatable, Unboxable {
        let image: String
    
        // MARK: - Unboxable
        init(unboxer: Unboxer) throws {
            // Kludge to reflect the strange API behavior - it pass only path sometimes
            let imageUrl: String = try unboxer.unbox(key: "image")
            image = imageUrl.hasPrefix(baseUrl) ? imageUrl : baseUrl + imageUrl
        }
        
        // MARK: - Equatable
        static func ==(left: Avatar, right: Avatar) -> Bool {
            return left.image == right.image
        }
    }
    
    struct License: Equatable, Unboxable {
        let id: String
        let title: String
        
        // MARK: - Unboxable
        init(unboxer: Unboxer) throws {
            id = try unboxer.unbox(key: "id")
            title = try unboxer.unbox(key: "title")
        }
        
        // MARK: - Equatable
        static func ==(left: License, right: License) -> Bool {
            return left.id == right.id && left.title == right.title
        }
    }
    
    let id: String
    let avatar: Avatar?
    let name: String?
    let licenses: [License]
    let phone: String?
    let email: String?
    
    // MARK: - Unboxable
    init(unboxer: Unboxer) throws {
        avatar = unboxer.unbox(key: "avatar")
        name = unboxer.unbox(key: "first_name") // TODO: return `name` back
        licenses = try unboxer.unbox(key: "licenses")
        phone = unboxer.unbox(key: "phone")
        email = unboxer.unbox(key: "email")
        id = try unboxer.unbox(key: "id")
    }
    
    // MARK: - Equatable
    static func ==(left: User, right: User) -> Bool {
        return left.avatar == right.avatar
            && left.licenses == right.licenses
            && left.name == right.name
            && left.phone == right.phone
            && left.email == right.email
            && left.id == right.id
    }
}


