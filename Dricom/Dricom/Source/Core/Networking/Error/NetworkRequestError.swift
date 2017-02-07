enum NetworkRequestError: Error {
    case badRequest
    case parsingFailure
    case internalServerError
    case userIsNotAuthorized
    case apiError(ApiError)
    case unknownError(Error)
}
