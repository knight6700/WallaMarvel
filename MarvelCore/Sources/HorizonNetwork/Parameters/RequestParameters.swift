import Foundation
import CryptoKit
import HorizonKeys

public struct BaseRequestParameters: Encodable {
     let apiKey: String
     let timeStamp: String
     let hash: String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "apikey"
        case timeStamp = "ts"
        case hash
    }
    
    public init() {
        self.timeStamp = String(Int(Date().timeIntervalSince1970))
        self.apiKey = AppConfig.publicKey
        self.hash = MD5HashGenerator(
            timeStamp: timeStamp,
            privateKey: AppConfig.privateKey,
            apiKey: apiKey
        ).generate()
    }
     
}
