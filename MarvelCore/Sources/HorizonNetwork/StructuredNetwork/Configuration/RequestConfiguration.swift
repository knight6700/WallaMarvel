import Foundation

public struct RequestConfiguration {

    // MARK: - Properties

    let path: String
    let method: HTTPMethod
    let headers: [HTTPHeader]?
    let parameters: RequestParameters?
    let encoding: ParameterEncoding?
    public init(
        method: HTTPMethod = .get,
        path: String,
        parameters: RequestParameters? = nil,
        encoding: ParameterEncoding = .UrlEncoding
    ) {
        self.path = path
        self.method = method
        self.headers = [
            HTTPHeader(name: "Accept", value: "application/json"),
            HTTPHeader(name: "Content-Type", value: "application/json")
        ]
        self.parameters = parameters
        self.encoding = encoding
    }
}
