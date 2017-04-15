enum NetworkRequestError: Error {
    case badRequest
    case parsingFailure
    case dataEncodingFailure
    case userIsNotAuthorized
    case internalServerError
    case wrongInputParameters(message: String)
    case apiError(ApiError)
    case unknownError(Error)
}
