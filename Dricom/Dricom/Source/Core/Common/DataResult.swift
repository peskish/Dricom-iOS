// MARK: - ApiResult
typealias ApiResult<T> = DataResult<T, NetworkError>

// MARK: - DataResult

enum DataResult<T, E> {
    case data(T)
    case error(E)
    
    public typealias Completion = (DataResult) -> ()
    
    public typealias DataType = T
    public typealias ErrorType = E
    
    public var data: T? {
        switch self {
        case .data(let data):
            return data
        case .error:
            return nil
        }
    }
    
    public var error: E? {
        switch self {
        case .error(let error):
            return error
        case .data:
            return nil
        }
    }
    
    public var isError: Bool {
        switch self {
        case .error:
            return true
        case .data:
            return false
        }
    }
    
    public func onData(_ closure: (T) -> ()) {
        if let data = data {
            closure(data)
        }
    }
    
    public func onError(_ closure: (E) -> ()) {
        if let error = error {
            closure(error)
        }
    }
    
    public func map<U>(_ transform: (T) throws -> U) rethrows -> DataResult<U, E> {
        switch self {
        case .data(let data):
            return try .data(transform(data))
        case .error(let error):
            return .error(error)
        }
    }
    
    public func flatMap<U>(_ transform: (T) throws -> DataResult<U, E>) rethrows -> DataResult<U, E> {
        switch self {
        case .data(let data):
            return try transform(data)
        case .error(let error):
            return .error(error)
        }
    }
}
