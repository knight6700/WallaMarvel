import Foundation
import CryptoKit
import HorizonKeys

public protocol BaseRequestable: Encodable {
    var apikey: String { get }
    var ts: String { get }
    var hash: String { get }
}

public class BaseRequestParameters: BaseRequestable {
    public let apikey: String
    public let ts: String
    public let hash: String

    public init() {
        self.ts = String(Int(Date().timeIntervalSince1970))
        self.apikey = AppConfig.keys.publicKey
        self.hash = "\(ts)\(AppConfig.keys.privateKey)\(apikey)".md5
    }
}
public protocol RequestParameters: Encodable {
    var baseRequesParameter: BaseRequestParameters { get }
}

 extension String {
    var md5: String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map { .init(format: "%02hhx", $0) }.joined()
    }
}
