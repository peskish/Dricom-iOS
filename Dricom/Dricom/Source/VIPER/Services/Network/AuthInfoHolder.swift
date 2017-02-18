import KeychainAccess

protocol LastSuccessLoginHolder {
    var lastSuccessLogin: String? { get }
}

enum AuthorizationStatus {
    case notAuthorized
    case authorized(jwt: String)
}

protocol AuthorizationStatusHolder: class {
    var authorizationStatus: AuthorizationStatus { get }
}

protocol LoginResponseProcessor: class {
    func processLoginResponse(_ loginResponse: LoginResponse)
}

final class AuthInfoHolder:
    LastSuccessLoginHolder,
    AuthorizationStatusHolder,
    LoginResponseProcessor
{
    private let syncQueue = DispatchQueue(label: "ru.dricom.AuthInfoHolderImpl.syncQueue")
    private let authInfoKeychainService = "ru.dricom.keychain.authInfo"
    
    private let jwtKey = "jwt"
    private let lastSuccessLoginKey = "lastSuccessLogin"
    
    // MARK: - In-memory storage
    private var jwtStorage: String?
    private var lastSuccessLoginStorage: String?
    
    // MARK: - Init
    init() {
        // Load persistent session info once
        let loadedAuthInfo = loadSessionInfo()
        jwtStorage = loadedAuthInfo.jwt
        lastSuccessLoginStorage = loadedAuthInfo.lastSuccessLogin
    }
    
    // MARK: - LoginResponseProcessor
    func processLoginResponse(_ loginResponse: LoginResponse) {
        syncQueue.async {
            let authInfoKeychain = Keychain(service: self.authInfoKeychainService)
                .accessibility(.afterFirstUnlock)
            
            self.lastSuccessLoginStorage = loginResponse.user.email
            self.jwtStorage = loginResponse.jwt
            
            try? authInfoKeychain.removeAll()
            try? authInfoKeychain.set(loginResponse.jwt, key: self.jwtKey)
            if let email = loginResponse.user.email {
                try? authInfoKeychain.set(email, key: self.lastSuccessLoginKey)
            }
        }
    }
    
    // MARK: - LastSuccessLoginHolder
    var lastSuccessLogin: String? {
        get {
            var result: String?
            syncQueue.sync {
                result = self.lastSuccessLoginStorage
            }
            return result
        }
    }
    
    // MARK: - AuthorizationStatusHolder
    var jwt: String? {
        get {
            var result: String?
            syncQueue.sync {
                result = self.jwtStorage
            }
            return result
        }
    }
    
    var authorizationStatus: AuthorizationStatus {
        if let jwt = jwt {
            return .authorized(jwt: jwt)
        } else {
            return .notAuthorized
        }
    }
    
    // MARK: - Private
    private func loadSessionInfo() -> (jwt: String?, lastSuccessLogin: String?) {
        let authInfoKeychain = Keychain(service: authInfoKeychainService)
            .accessibility(.afterFirstUnlock)
        
        return (jwt: authInfoKeychain[jwtKey], lastSuccessLogin: authInfoKeychain[lastSuccessLoginKey])
    }
}
