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
    var isAuthorized: Bool { get }
}

protocol LoginResponseProcessor: class {
    func processLoginResponse(_ loginResponse: LoginResponse)
}

protocol LogoutService: class {
    func processLogoutAction(completion: (() -> ())?)
}

final class AuthInfoHolder:
    LastSuccessLoginHolder,
    AuthorizationStatusHolder,
    LoginResponseProcessor,
    LogoutService
{
    // MARK: - Properties
    private let syncQueue = DispatchQueue(label: "ru.dricom.AuthInfoHolderImpl.syncQueue")
    
    // MARK: - Keys
    private let authInfoKeychainServiceKey = "ru.dricom.keychain.authInfo"
    
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
            let authInfoKeychain = Keychain(service: self.authInfoKeychainServiceKey)
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
    
    // MARK: - LogoutService
    func processLogoutAction(completion: (() -> ())?) {
        syncQueue.async {
            self.jwtStorage = nil
            
            let authInfoKeychain = Keychain(service: self.authInfoKeychainServiceKey)
                .accessibility(.afterFirstUnlock)
            
            try? authInfoKeychain.remove(self.jwtKey)
            
            DispatchQueue.main.async {
                completion?()
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
    
    var isAuthorized: Bool {
        switch authorizationStatus {
        case .authorized:
            return true
        case .notAuthorized:
            return false
        }
    }
    
    // MARK: - Private
    private func loadSessionInfo() -> (jwt: String?, lastSuccessLogin: String?) {
        let authInfoKeychain = Keychain(service: authInfoKeychainServiceKey)
            .accessibility(.afterFirstUnlock)
        
        return (jwt: authInfoKeychain[jwtKey], lastSuccessLogin: authInfoKeychain[lastSuccessLoginKey])
    }
}
