protocol AuthorizationService: class {
    func login(userName: String, password: String, completion: ApiResult<Void>.Completion)
}
