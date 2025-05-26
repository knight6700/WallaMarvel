import Foundation
import CryptoKit
import HorizonKeys

public struct BaseRequestParameters: Encodable {
    public let apikey: String
    public let ts: String
    public let hash: String

    public init() {
        self.ts = String(Int(Date().timeIntervalSince1970))
        self.apikey = AppConfig.publicKey
        self.hash = "\(ts)\(AppConfig.privateKey)\(apikey)".md5
    }
}
 extension String {
    var md5: String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map { .init(format: "%02hhx", $0) }.joined()
    }
}
