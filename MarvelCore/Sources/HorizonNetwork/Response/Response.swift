import Foundation
public struct Response<T: Decodable>: Decodable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    public let data: T

    public init(
        code: Int,
        status: String,
        copyright: String,
        attributionText: String,
        attributionHTML: String,
        etag: String,
        data: T
    ) {
        self.code = code
        self.status = status
        self.copyright = copyright
        self.attributionText = attributionText
        self.attributionHTML = attributionHTML
        self.etag = etag
        self.data = data
    }
}
