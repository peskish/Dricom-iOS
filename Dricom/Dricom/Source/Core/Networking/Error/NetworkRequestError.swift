enum NetworkRequestError: Error {
    case badRequest
    case parsingFailure
    case userIsNotAuthorized
    case internalServerError
    case apiError(ApiError)
    case unknownError(Error)
}
