enum DataLoadingResult<T> {
    case loaded(data: T)
    case error(error: NetworkRequestError, previousResult: T?)
    
    func cachedData() -> T? {
        switch self {
        case .loaded(let data):
            return data
        case .error(_, let previousData):
            return previousData
        }
    }
}

enum DataLoadingState<T> {
    case pending
    case loading
    case completed(result: DataLoadingResult<T>)
    
    init() { self = .pending }
    
    func previousLoadedData() -> T? {
        switch self {
        case .pending,
             .loading:
            return nil
        case .completed(let result):
            return result.cachedData()
        }
    }
}
