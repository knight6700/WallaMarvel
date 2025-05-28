import Foundation
import CryptoKit

public struct MD5HashGenerator {
    private let timeStamp: String
    private let privateKey: String
    private let apiKey: String
    public init(
        timeStamp: String,
        privateKey: String,
        apiKey: String
    ) {
        self.timeStamp = timeStamp
        self.privateKey = privateKey
        self.apiKey = apiKey
    }
    
    func generate() -> String {
        let hash = "\(timeStamp)\(privateKey)\(apiKey)"
        let digest = Insecure.MD5.hash(data: hash.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
